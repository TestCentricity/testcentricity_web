module TestCentricity
  class List < UIElement
    attr_accessor :list_item

    def initialize(parent, locator, context)
      @parent  = parent
      @locator = locator
      @context = context
      @type    = :list
      @alt_locator = nil
      list_spec = { :list_item => 'li' }
      define_list_elements(list_spec)
    end

    def define_list_elements(element_spec)
      element_spec.each do | element, value |
        case element
          when :list_item
            @list_item = value
        end
      end
    end

    def get_list_items
      obj, _ = find_element
      object_not_found_exception(obj, nil)
      obj.all(@list_item).collect(&:text)
    end
  end
end
