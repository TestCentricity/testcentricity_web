module TestCentricity
  class ListElement < UIElement
    attr_accessor :list
    attr_accessor :element_locator

    def initialize(name, parent, locator, context, list)
      @name            = name
      @parent          = parent
      @context         = context
      @alt_locator     = nil
      @list            = list
      @element_locator = locator
      locator.nil? ?
          @locator = list.get_list_row_locator('ROW_SPEC') :
          @locator = "#{list.get_list_row_locator('ROW_SPEC')}/#{@element_locator}"
    end

    def exists?(row)
      obj, = find_list_element(row)
      obj != nil
    end

    def click(row)
      obj, = find_list_element(row)
      list_object_not_found_exception(obj, @type, row)
      obj.click
    end

    def get_value(row, visible = true)
      obj, = find_list_element(row, visible)
      list_object_not_found_exception(obj, @type, row)
      case obj.tag_name.downcase
        when 'input', 'select', 'textarea'
          obj.value
        else
          obj.text
      end
    end

    alias get_caption get_value

    def find_list_element(row, visible = true)
      set_alt_locator("#{@locator.gsub('ROW_SPEC', row.to_s)}")
      find_element(visible)
    end

    def list_object_not_found_exception(obj, obj_type, row)
      object_not_found_exception(obj, "Row #{row} #{obj_type}")
    end
  end
end
