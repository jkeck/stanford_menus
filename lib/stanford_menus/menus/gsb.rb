require 'faraday'
require 'json'

module StanfordMenus
  module Menus
    class GSB
      URL = 'https://stanfordgsb.cafebonappetit.com/'.freeze

      def all(&_block)
        (block_given? ? yield(grouped_items) : grouped_items).map do |station, items|
          Struct.new(:station, :items).new(station, items)
        end
      end

      def filtered_by_category(station_query)
        normalized_query = normalize_station(station_query)
        all do |grouped_items|
          grouped_items.select do |station, _|
            (normalize_station(station) & normalized_query).any? ||
              normalize_station(station).join('').include?(normalized_query.join(''))
          end
        end
      end

      def filtered_by_price(price_query)
        all do |grouped_items|
          grouped_items.each_with_object({}) do |(station, items), hash|
            next unless (filted_items = items.select { |item| item.costs_less_than?(price_query) }).any?
            hash[station] = filted_items
          end
        end
      end

      private

      def grouped_items
        items.select(&:special).group_by(&:station)
      end

      def normalize_station(string)
        string
          .downcase
          .gsub(/[[:punct:]]/, ' ')
          .split(/\s/)
          .compact
          .reject(&:empty?)
      end

      def items
        return to_enum(:items) unless block_given?
        json.values.each do |item_json|
          yield Item.new(item_json)
        end
      end

      def json
        JSON.parse(json_string_from_response)
      end

      def response
        @response ||= Faraday.get(URL).body
      end

      def json_string_from_response
        @json_string_from_response ||= begin
          response[/Bamco\.menu_items = (.*)\n/]
          Regexp.last_match.to_s.gsub(/;$/, '').gsub('Bamco.menu_items = ', '')
        end
      end

      class Item
        attr_reader :json
        def initialize(json)
          @json = json
        end

        def label
          json['label']
        end

        def description
          json['description']
        end

        def station
          json['station'].gsub(%r{</?strong>}, '').gsub(/^@/, '')
        end

        def special
          json['special'] == 1
        end

        def costs_less_than?(price)
          price = price.sub(/^\$/, '').to_f
          price_floats.any? { |item_price| item_price <= price }
        end

        def price_floats
          prices = !sizes.empty? ? sizes.map(&:price) : [json['price']]
          prices.map do |price|
            price.sub(/^\$/, '').to_f
          end
        end

        def price
          return json['price'] if sizes.empty?

          sizes.map do |size|
            "#{size.price} (#{size.size})"
          end.join(' | ')
        end

        def sizes
          return [] unless json['sizes']

          json['sizes'].map do |size|
            Struct.new(:size, :price).new(size['size'], size['price'])
          end
        end

        def to_s
          "#{label} [#{price}]\n\t#{description}\n\n"
        end
      end
    end
  end
end

StanfordMenus.restaurant_class_map['GSB'] = 'StanfordMenus::Menus::GSB'
