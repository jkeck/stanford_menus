module StanfordMenus
  module Menus
    autoload :GSB, 'stanford_menus/menus/gsb'

    def self.for(restaurant)
      klass = StanfordMenus.restaurant_class_map[restaurant]
      raise ArgumentError, "\"#{restaurant}\" is not a registered restaurant" unless klass

      begin
        Object.const_get(klass).new
      rescue NameError
        raise ArgumentError, "The class \"#{klass}\" configured for \"#{restaurant}\" is not an available"
      end
    end
  end
end
