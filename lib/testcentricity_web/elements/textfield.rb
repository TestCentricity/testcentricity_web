module TestCentricity
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
      min.to_i unless min.blank?
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
      max.to_i unless max.blank?
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
      step.to_i unless step.blank?
    end
  end
end
