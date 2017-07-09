module TestCentricity
  class CellCheckBox < CellElement
    attr_accessor :proxy

    def initialize(name, parent, locator, context, table, column, proxy = nil)
      super
      @type  = :cell_checkbox
      @proxy = proxy
    end

    def checked?(row)
      obj, = find_cell_element(row)
      cell_object_not_found_exception(obj, 'Cell CheckBox', row)
      obj.checked?
    end

    def set_checkbox_state(row, state)
      obj, = find_cell_element(row)
      cell_object_not_found_exception(obj, 'Cell CheckBox', row)
      obj.set(state)
    end

    def check(row)
      set_checkbox_state(row, true)
    end

    def uncheck(row)
      set_checkbox_state(row, false)
    end

    def verify_check_state(row, state, enqueue = false)
      actual = checked?(row)
      enqueue ?
          ExceptionQueue.enqueue_assert_equal(state, actual, "Expected Row #{row}/Col #{@column} Cell Checkbox #{object_ref_message}") :
          assert_equal(state, actual, "Expected Row #{row}/Col #{@column} Cell Checkbox #{object_ref_message} to be #{state} but found #{actual} instead")
    end
  end
end
