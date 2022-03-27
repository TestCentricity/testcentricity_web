module TestCentricity
  class CheckBox < UIElement
    attr_accessor :proxy
    attr_accessor :label

    def initialize(name, parent, locator, context)
      super
      @type = :checkbox
      check_spec = {
        proxy: nil,
        label: nil
      }
      define_custom_elements(check_spec)
    end

    def define_custom_elements(element_spec)
      element_spec.each do |element, value|
        case element
        when :proxy
          @proxy = value
        when :label
          @label = value
        else
          raise "#{element} is not a recognized checkbox element"
        end
      end
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
      @proxy.nil? ? super : page.find(:css, @proxy).visible?
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
      if @label.nil?
        @proxy.nil? ? super : page.find(:css, @proxy).text
      else
        page.find(:css, @label).text
      end
    end

    alias get_caption get_value
    alias caption get_value
    alias value get_value

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
        begin
          obj.set(state)
        rescue
          obj.click unless state == obj.checked?
        end
      else
        page.find(:css, @proxy).click unless state == obj.checked?
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
      set_checkbox_state(state = false)
    end

    def verify_check_state(state, enqueue = false)
      actual = checked?
      enqueue ?
          ExceptionQueue.enqueue_assert_equal(state, actual, "Expected checkbox #{object_ref_message}") :
          assert_equal(state, actual, "Expected checkbox #{object_ref_message} to be #{state} but found #{actual} instead")
    end
  end
end
