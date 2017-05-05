module TestCentricity
  class ListCheckBox < ListElement
    attr_accessor :proxy

    def initialize(name, parent, locator, context, list, proxy)
      super
      @type  = :list_checkbox
      @proxy = proxy
    end

    def checked?(row)
      obj, = find_list_element(row)
      list_object_not_found_exception(obj, 'List CheckBox', row)
      obj.checked?
    end

    def set_checkbox_state(row, state)
      obj, = find_list_element(row)
      list_object_not_found_exception(obj, 'List CheckBox', row)
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
          ExceptionQueue.enqueue_assert_equal(state, actual, "Expected Row #{row} List Checkbox #{object_ref_message}") :
          assert_equal(state, actual, "Expected Row #{row} List Checkbox #{object_ref_message} to be #{state} but found #{actual} instead")
    end
  end
end
