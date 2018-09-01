require 'stanford_menus/version'
require 'stanford_menus/menus'

module StanfordMenus
  autoload :CLI, 'stanford_menus/cli'
  autoload :StdoutPrinter, 'stanford_menus/stdout_printer'

  class << self
    attr_writer :renderer, :restaurant_class_map
    def restaurant_class_map
      @restaurant_class_map ||= {}
    end

    def renderer
      @renderer || StdoutPrinter
    end
  end
end
