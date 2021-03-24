module TestCentricity
  class CheckBox < UIElement
    attr_accessor :proxy

    def initialize(name, parent, locator, context, proxy = nil)
      @name        = name
      @parent      = parent
      @locator     = locator
      @context     = context
      @alt_locator = nil
      @proxy       = proxy
      @type        = :checkbox
      set_locator_type
    end

    # Does checkbox object exists?
    #
    # @return [Boolean]
    # @example
    #   remember_me_checkbox.exists?
    #
    def exists?
      obj, = find_object(:all)
      obj != nil
    end

    # Is checkbox checked?
    #
    # @return [Boolean]
    # @example
    #   remember_me_checkbox.checked?
    #
    def checked?
      obj, = find_element(:all)
      object_not_found_exception(obj, 'Checkbox')
      obj.checked?
    end

    # Is checkbox state indeterminate?
    #
    # @return [Boolean]
    # @example
    #   remember_me_checkbox.indeterminate?
    #
    def indeterminate?
      state = get_attribute('indeterminate')
      state.boolean? ? state : state == 'true'
    end

    # Is checkbox visible?
    #
    # @return [Boolean]
    # @example
    #   remember_me_checkbox.visible?
    #
    def visible?
      @proxy.nil? ? super : @proxy.visible?
    end

    # Is checkbox disabled (not enabled)?
    #
    # @return [Boolean]
    # @example
    #   remember_me_checkbox.disabled?
    #
    def disabled?
      visibility = @proxy.nil? ? true : :all
      obj, type = find_element(visibility)
      object_not_found_exception(obj, type)
      obj.disabled?
    end

    # Return checkbox caption
    #
    # @return [Boolean]
    # @example
    #   remember_me_checkbox.get_value
    #
    def get_value
      @proxy.nil? ? super : @proxy.get_value
    end

    # Set the check state of a checkbox object.
    #
    # @param state [Boolean] true = checked / false = unchecked
    # @example
    #   remember_me_checkbox.set_checkbox_state(true)
    #
    def set_checkbox_state(state)
      obj, = find_element(:all)
      object_not_found_exception(obj, 'Checkbox')
      invalid_object_type_exception(obj, 'checkbox')
      if @proxy.nil?
        if obj.native.attribute('ot') == 'JCheckBox'
          expected = state.to_bool
          obj.click unless expected == obj.checked?
        else
          obj.set(state)
        end
      else
        @proxy.click unless state == obj.checked?
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
          ExceptionQueue.enqueue_assert_equal(state, actual, "Expected checkbox #{object_ref_message}") :
          assert_equal(state, actual, "Expected checkbox #{object_ref_message} to be #{state} but found #{actual} instead")
    end

    # Highlight a checkbox with a 3 pixel wide, red dashed border for the specified wait time.
    # If wait time is zero, then the highlight will remain until the page is refreshed
    #
    # @param duration [Integer or Float] wait time in seconds
    # @example
    #   remember_me_checkbox.highlight(3)
    #
    def highlight(duration = 1)
      @proxy.nil? ? super : @proxy.highlight(duration)
    end

    # Restore a highlighted checkbox's original style
    #
    # @example
    #   remember_me_checkbox.unhighlight
    #
    def unhighlight
      @proxy.nil? ? super : @proxy.unhighlight
    end
  end
end
