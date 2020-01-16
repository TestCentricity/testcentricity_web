module TestCentricity
  class Range < TextField
    def initialize(name, parent, locator, context)
      super
      @type = :range
    end

    # Set the value property of a range type input object.
    #
    # @param value [Integer]
    # @example
    #   volume_level.value = 11
    #
    def value=(value)
      obj, = find_element
      object_not_found_exception(obj, nil)
      page.execute_script('arguments[0].value = arguments[1]', obj, value)
      obj.send_keys(:right)
    end

    def get_value(visible = true)
      obj, type = find_element(visible)
      object_not_found_exception(obj, type)
      result = obj.value
      unless result.blank?
        if result.is_int?
          result.to_i
        elsif result.is_float?
          result.to_f
        else
          result
        end
      end
    end
  end
end
