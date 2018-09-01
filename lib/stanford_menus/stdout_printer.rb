module StanfordMenus
  class StdoutPrinter
    attr_reader :restaurants
    def initialize(restaurants)
      @restaurants = restaurants
    end

    def render
      restaurants.each do |menus|
        menus.each do |menu|
          puts menu.station
          menu.items.each { |item| puts "\t#{item}" }
        end
      end
    end
  end
end
