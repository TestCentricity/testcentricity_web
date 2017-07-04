module TestCentricity
  class CellElement < UIElement
    attr_accessor :table
    attr_accessor :column
    attr_accessor :element_locator

    def initialize(name, parent, locator, context, table, column, proxy = nil)
      @name            = name
      @parent          = parent
      @context         = context
      @alt_locator     = nil
      @table           = table
      @column          = column
      @element_locator = locator
      @locator         = "#{@table.get_table_cell_locator('ROW_SPEC', @column)}/#{@element_locator}"
    end

    def set_column(column)
      @column  = column
      @locator = "#{@table.get_table_cell_locator('ROW_SPEC', @column)}/#{@element_locator}"
    end

    def exists?(row)
      obj, = find_cell_element(row)
      obj != nil
    end

    def click(row)
      obj, = find_cell_element(row)
      cell_object_not_found_exception(obj, @type, row)
      obj.click
    end

    def get_value(row, visible = true)
      obj, = find_cell_element(row, visible)
      cell_object_not_found_exception(obj, @type, row)
      case obj.tag_name.downcase
        when 'input', 'select', 'textarea'
          obj.value
        else
          obj.text
      end
    end

    alias get_caption get_value

    def find_cell_element(row, visible = true)
      set_alt_locator("#{@locator.gsub('ROW_SPEC', row.to_s)}")
      find_element(visible)
    end

    def cell_object_not_found_exception(obj, obj_type, row)
      object_not_found_exception(obj, "Row #{row}/Col #{@column} #{obj_type}")
    end
  end
end
