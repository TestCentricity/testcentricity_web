module TestCentricity
  class CellRadio < CellElement
    attr_accessor :proxy

    def initialize(name, parent, locator, context, table, column, proxy)
      super
      @type  = :cell_radio
      @proxy = proxy
    end

    def selected?(row)
      obj, = find_cell_element(row)
      cell_object_not_found_exception(obj, 'Cell Radio', row)
      obj.checked?
    end

    def set_selected_state(row, state)
      obj, = find_cell_element(row)
      cell_object_not_found_exception(obj, 'Cell Radio', row)
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
