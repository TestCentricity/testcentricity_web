module TestCentricity
  module Elements
    class TextField < UIElement
      def initialize(name, parent, locator, context)
        super
        @type = :textfield
      end

      # Is text field set to read-only?
      #
      # @return [Boolean]
      # @example
      #   comments_field.read_only?
      #
      def read_only?
        obj, = find_element
        object_not_found_exception(obj, nil)
        !!obj.native.attribute('readonly')
      end

      # Return maxlength character count of a text field.
      #
      # @return [Integer]
      # @example
      #   max_num_chars = comments_field.get_max_length
      #
      def get_max_length
        obj, = find_element
        object_not_found_exception(obj, nil)
        max_length = obj.native.attribute('maxlength')
        max_length.to_i unless max_length.blank?
      end

      # Return placeholder text of a text field.
      #
      # @return [String]
      # @example
      #   placeholder_message = username_field.get_placeholder
      #
      def get_placeholder
        obj, = find_element
        object_not_found_exception(obj, nil)
        obj.native.attribute('placeholder')
      end

      # Return validationMessage property of a textfield, which is the message the browser displays to the user when a textfield's
      # validity is checked and fails. Note that each web browser provides a default localized message for this property, and message
      # strings can vary between different browsers (Chrome/Edge vs Firefox vs Safari).
      #
      # @return [String]
      # @example
      #   message = username_field.validation_message
      #
      def validation_message
        obj, = find_element
        object_not_found_exception(obj, nil)
        obj.native.attribute('validationMessage')
      end

      # Return Boolean value representing
      #
      # @param validity_state [Symbol] property to verify
      # @return [Boolean]
      # @example
      #   username_field.validity?(:valid)
      #   username_field.validity?(:valueMissing)
      #
      def validity?(validity_state)
        obj, = find_element
        object_not_found_exception(obj, nil)
        page.execute_script("return arguments[0].validity.#{validity_state}", obj)
      end

      # Return min attribute of a number type text field.
      #
      # @return [Integer]
      # @example
      #   min_points_value = points_field.get_min
      #
      def get_min
        obj, = find_element
        object_not_found_exception(obj, nil)
        min = obj.native.attribute('min')
        unless min.blank?
          if min.is_int?
            min.to_i
          elsif min.is_float?
            min.to_f
          else
            min
          end
        end
      end

      # Return max attribute of a number type text field.
      #
      # @return [Integer]
      # @example
      #   max_points_value = points_field.get_max
      #
      def get_max
        obj, = find_element
        object_not_found_exception(obj, nil)
        max = obj.native.attribute('max')
        unless max.blank?
          if max.is_int?
            max.to_i
          elsif max.is_float?
            max.to_f
          else
            max
          end
        end
      end

      # Return step attribute of a number type text field.
      #
      # @return [Integer]
      # @example
      #   points_step = points_field.get_step
      #
      def get_step
        obj, = find_element
        object_not_found_exception(obj, nil)
        step = obj.native.attribute('step')
        unless step.blank?
          if step.is_int?
            step.to_i
          elsif step.is_float?
            step.to_f
          else
            step
          end
        end
      end

      # Clear the contents of a text field
      #
      # @example
      #   first_name_field.clear
      #
      def clear
        field_type = get_native_attribute('tagName')
        field_type = field_type.downcase.to_sym unless field_type.nil?
        case field_type
        when :textarea
          set('')
          sleep(0.5)
          send_keys(:tab)
        when :div, nil
          set('')
        else
          length = get_value.length
          length.times do
            send_keys(:backspace)
          end
          sleep(0.5)
          if get_value.length > 0
            set('')
            sleep(0.5)
            send_keys(:tab)
          end
        end
      end
    end
  end
end
