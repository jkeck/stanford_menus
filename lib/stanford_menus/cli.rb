require 'stanford_menus/menus/gsb'

module StanfordMenus
  # stanford_menus --all
  # stanford_menus --for GSB
  # stanford_menus --for GSB --category action
  class CLI < Thor
    desc 'all', 'Print menus for all restaurants (defualt)'
    option :for, type: :string, aliases: :f, banner: 'The key of the a specific restaurant to print a menu for. (Example: GSB)'
    option :category, type: :string, aliases: :c, banner: 'A string to filter the menu on. This is restaurant specific. (Example: "market grill")'
    option :price, type: :string, aliases: :p, banner: 'A number to filter the price on. (Example: 7, or \$5)'
    def all
      menus = if options[:category]
                restaurants.map do |restaurant|
                  restaurant.filtered_by_category(options[:category])
                end
              elsif options[:price]
                restaurants.map do |restaurant|
                  restaurant.filtered_by_price(options[:price])
                end
              else
                restaurants.map(&:all)
              end

      StanfordMenus.renderer.new(menus).render
    end
    default_task :all

    private

    def restaurants
      if options[:for]
        [StanfordMenus::Menus.for(options[:for])]
      else
        StanfordMenus.restaurant_class_map.keys.map do |restaurant|
          StanfordMenus::Menus.for(restaurant)
        end
      end
    end
  end
end
