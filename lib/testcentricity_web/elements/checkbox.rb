module TestCentricity
  class CheckBox < UIElement

    def initialize(parent, locator, context)
      @parent  = parent
      @locator = locator
      @context = context
      @type    = :checkbox
      @alt_locator = nil
    end

    # Does checkbox object exists?
    #
    # @return [Boolean]
    # @example
    #   remember_me_checkbox.exists?
    #
    def exists?
      obj, _ = find_object(:all)
      obj != nil
    end

    # Is checkbox checked?
    #
    # @return [Boolean]
    # @example
    #   remember_me_checkbox.checked?
    #
    def checked?
      obj, _ = find_element(:all)
      object_not_found_exception(obj, 'Checkbox')
      obj.checked?
    end

    # Set the check state of a checkbox object.
    #
    # @param state [Boolean] true = checked / false = unchecked
    # @example
    #   remember_me_checkbox.set_checkbox_state(true)
    #
    def set_checkbox_state(state)
      obj, _ = find_element(:all)
      object_not_found_exception(obj, 'Checkbox')
      invalid_object_type_exception(obj, 'checkbox')
      begin
        obj.set(state)
      rescue
        unless state == obj.checked?
          check_id = obj.native.attribute('id')
          label = first("label[for='#{check_id}']")
          label.click if label.exists?
        end
      end
    end

    # Set the check state of a checkbox object.
    #
    # @example
    #   remember_me_checkbox.check
    #
    def check
      set_checkbox_state(true)
    end

    # Uncheck a checkbox object.
    #
    # @example
    #   remember_me_checkbox.uncheck
    #
    def uncheck
      set_checkbox_state(false)
    end

    def verify_check_state(state, enqueue = false)
      actual = checked?
      enqueue ?
          ExceptionQueue.enqueue_assert_equal(state, actual, "Expected #{@locator}") :
          assert_equal(state, actual, "Expected #{@locator} to be #{state} but found #{actual} instead")
    end

    # Set the check state of a Siebel OUI JCheckBox object.
    #
    # @param state [Boolean] true = checked / false = unchecked
    # @example
    #   remember_me_checkbox.set_siebel_checkbox_state(true)
    #
    def set_siebel_checkbox_state(state)
      obj, _ = find_element
      object_not_found_exception(obj, 'Siebel checkbox')
      raise "#{locator} is not a Siebel CheckBox object" unless get_siebel_object_type == 'JCheckBox'
      expected = state.to_bool
      obj.click unless expected == obj.checked?
    end
  end
end
