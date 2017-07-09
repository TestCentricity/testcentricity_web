module TestCentricity
  class ListRadio < ListElement
    attr_accessor :proxy

    def initialize(name, parent, locator, context, list, proxy = nil)
      super
      @type  = :list_radio
      @proxy = proxy
    end

    def selected?(row)
      obj, = find_list_element(row)
      list_object_not_found_exception(obj, 'List Radio', row)
      obj.checked?
    end

    def set_selected_state(row, state)
      obj, = find_list_element(row)
      list_object_not_found_exception(obj, 'List Radio', row)
      obj.set(state)
    end

    def select(row)
      set_selected_state(row, true)
    end

    def unselect(row)
      set_selected_state(row, false)
    end
  end
end
