module TestCentricity
  module Elements
    class Radio < UIElement
      attr_accessor :proxy
      attr_accessor :label
      attr_accessor :input

      def initialize(name, parent, locator, context)
        super
        @type = :radio
        radio_spec = {
          input: nil,
          proxy: nil,
          label: nil
        }
        define_custom_elements(radio_spec)
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
            raise "#{element} is not a recognized radio element"
          end
        end
      end

      # Does radio button object exists?
      #
      # @return [Boolean]
      # @example
      #   accept_terms_radio.exists?
      #
      def exists?
        obj, = find_object(:all)
        obj != nil
      end

      # Is radio button selected?
      #
      # @return [Boolean]
      # @example
      #   accept_terms_radio.selected?
      #
      def selected?
        @base_object, = find_element(:all)
        object_not_found_exception(@base_object, 'Radio')
        rad = if @input.nil?
                @base_object
              else
                find_component(@input, 'Radio')
              end
        rad.checked?
      end

      # Is radio button visible?
      #
      # @return [Boolean]
      # @example
      #   accept_terms_radio.visible?
      #
      def visible?
        if @proxy.nil?
          super
        else
          @base_object, = find_element(:all)
          object_not_found_exception(@base_object, 'Radio')
          proxy = find_component(@proxy, 'radio proxy')
          proxy.visible?
        end
      end

      # Is radio button disabled (not enabled)?
      #
      # @return [Boolean]
      # @example
      #   accept_terms_radio.disabled?
      #
      def disabled?
        if @input.nil?
          super
        else
          @base_object, = find_element(:all)
          object_not_found_exception(@base_object, 'Radio')
          rad = find_component(@input, 'radio')
          rad.disabled?
        end
      end

      # Return radio button caption
      #
      # @return [Boolean]
      # @example
      #   accept_terms_radio.get_value
      #
      def get_value
        if @label.nil?
          if @proxy.nil?
            super
          else
            proxy = find_component(@proxy, 'radio proxy')
            proxy.text
          end
        else
          label = find_component(@label, 'radio label')
          label.text
        end
      end

      alias get_caption get_value
      alias caption get_value
      alias value get_value

      # Set the select state of a radio button object.
      #
      # @param state [Boolean] true = selected / false = unselected
      # @example
      #   accept_terms_radio.set_selected_state(true)
      #
      def set_selected_state(state)
        @base_object, = find_element(:all)
        object_not_found_exception(@base_object, 'Radio')
        proxy = find_component(@proxy, 'radio proxy') unless @proxy.nil?
        rad = find_component(@input, 'radio') unless @input.nil?
        if @input.nil?
          if @proxy.nil?
            @base_object.click unless state == @base_object.checked?
          else
            proxy.click unless state == @base_object.checked?
          end
        else
          if @proxy.nil?
            @base_object.click unless state == rad.checked?
          else
            proxy.click unless state == rad.checked?
          end
        end
      end

      # Set the selected state of a radio button object.
      #
      # @example
      #   accept_terms_radio.select
      #
      def select
        set_selected_state(true)
      end

      # Unselect a radio button object.
      #
      # @example
      #   accept_terms_radio.unselect
      #
      def unselect
        set_selected_state(state = false)
      end
    end
  end
end
