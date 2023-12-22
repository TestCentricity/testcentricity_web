module TestCentricity
  module Elements
    class CheckBox < UIElement
      attr_accessor :proxy
      attr_accessor :label
      attr_accessor :input

      def initialize(name, parent, locator, context)
        super
        @type = :checkbox
        check_spec = {
          input: nil,
          proxy: nil,
          label: nil
        }
        define_custom_elements(check_spec)
      end

      def define_custom_elements(element_spec)
        element_spec.each do |element, value|
          case element
          when :input
            @input = value
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
        @base_object, = find_element(:all)
        object_not_found_exception(@base_object, 'Checkbox')
        chk = if @input.nil?
                @base_object
              else
                find_component(@input, 'checkbox')
              end
        chk.checked?
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
        if @proxy.nil?
          super
        else
          @base_object, = find_element(:all)
          object_not_found_exception(@base_object, 'Checkbox')
          proxy = find_component(@proxy, 'checkbox proxy')
          proxy.visible?
        end
      end

      # Is checkbox disabled (not enabled)?
      #
      # @return [Boolean]
      # @example
      #   remember_me_checkbox.disabled?
      #
      def disabled?
        if @input.nil?
          super
        else
          @base_object, = find_element(:all)
          object_not_found_exception(@base_object, 'Checkbox')
          chk = find_component(@input, 'checkbox')
          chk.disabled?
        end
      end

      # Return checkbox caption
      #
      # @return [Boolean]
      # @example
      #   remember_me_checkbox.get_value
      #
      def get_value
        if @label.nil?
          if @proxy.nil?
            super
          else
            proxy = find_component(@proxy, 'checkbox proxy')
            proxy.text
          end
        else
          label = find_component(@label, 'checkbox label')
          label.text
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
        @base_object, = find_element(:all)
        object_not_found_exception(@base_object, 'Checkbox')
        proxy = find_component(@proxy, 'checkbox proxy') unless @proxy.nil?
        chk = find_component(@input, 'checkbox') unless @input.nil?
        if @input.nil?
          if @proxy.nil?
            @base_object.click unless state == @base_object.checked?
          else
            proxy.click unless state == @base_object.checked?
          end
        else
          if @proxy.nil?
            @base_object.click unless state == chk.checked?
          else
            proxy.click unless state == chk.checked?
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
end
