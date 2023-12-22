module TestCentricity
  module Elements
    class Range < TextField
      def initialize(name, parent, locator, context)
        super
        @type = :range
      end

      def get_value(visible = true)
        obj, type = find_element(visible)
        object_not_found_exception(obj, type)
        result = obj.value
        unless result.blank?
          if result.is_int?
            result.to_i
          else
            result
          end
        end
      end
    end
  end
end
