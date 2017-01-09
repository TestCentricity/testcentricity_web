module TestCentricity
  class CellElement < UIElement
    attr_accessor :table
    attr_accessor :column

    def initialize(name, parent, locator, context, table, column)
      @name        = name
      @parent      = parent
      @context     = context
      @alt_locator = nil
      @table       = table
      @column      = column
      @locator     = "#{@table.get_table_cell_locator('ROW_SPEC', column)}/#{locator}"
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

    def find_cell_element(row)
      set_alt_locator("#{@locator.gsub('ROW_SPEC', row.to_s)}")
      find_element
    end

    def cell_object_not_found_exception(obj, obj_type, row)
      object_not_found_exception(obj, "Row #{row}/Col #{@column} #{obj_type}")
    end
  end
end
