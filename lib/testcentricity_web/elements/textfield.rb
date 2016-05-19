module TestCentricity
  class TextField < UIElement
    def initialize(parent, locator, context)
      @parent  = parent
      @locator = locator
      @context = context
      @type    = :textfield
      @alt_locator = nil
    end

    # Is text field set to read-only?
    #
    # @return [Boolean]
    # @example
    #   comments_field.read_only?
    #
    def read_only?
      obj, _ = find_element
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
      obj, _ = find_element
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
      obj, _ = find_element
      object_not_found_exception(obj, nil)
      obj.native.attribute('placeholder')
    end
  end
end
