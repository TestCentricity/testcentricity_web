module TestCentricity
  class Table < UIElement
    def initialize(parent, locator, context)
      @parent  = parent
      @locator = locator
      @context = context
      @type    = :table
      @alt_locator = nil
    end

    # Return number of rows in a table object.
    #
    # @return [Integer]
    # @example
    #   num_rows = list_table.get_row_count
    #
    def get_row_count
      wait_until_exists(5)
      row_count = page.all(:xpath, "#{@locator}/tbody/tr", :visible => :all).count
      row_count
    end

    # Return number of columns in a table object.
    #
    # @return [Integer]
    # @example
    #   num_columns = list_table.get_column_count
    #
    def get_column_count
      row_count = get_row_count
      if row_count == 0
        page.all(:xpath, "#{@locator}/thead/tr/th", :visible => :all).count
      else
        (row_count == 1) ?
            page.all(:xpath, "#{@locator}/tbody/tr/td", :visible => :all).count :
            page.all(:xpath, "#{@locator}/tbody/tr[2]/td", :visible => :all).count
      end
    end

    # Click in the specified cell in a table object.
    #
    # @param row [Integer] row number
    # @param column [Integer] column number
    # @example
    #   list_table.click_table_cell(3, 5)
    #
    def click_table_cell(row, column)
      row_count = get_row_count
      raise "Row #{row} exceeds number of rows (#{row_count}) in table #{@locator}" if row > row_count
      column_count = get_column_count
      raise "Column #{column} exceeds number of columns (#{column_count}) in table #{@locator}" if column > column_count
      set_table_cell_locator(row, column)
      click
      clear_alt_locator
    end

    # Double-click in the specified cell in a table object.
    #
    # @param row [Integer] row number
    # @param column [Integer] column number
    # @example
    #   list_table.double_click_table_cell(3, 5)
    #
    def double_click_table_cell(row, column)
      row_count = get_row_count
      raise "Row #{row} exceeds number of rows (#{row_count}) in table #{@locator}" if row > row_count
      column_count = get_column_count
      raise "Column #{column} exceeds number of columns (#{column_count}) in table #{@locator}" if column > column_count
      set_table_cell_locator(row, column)
      double_click
      clear_alt_locator
    end

    # Click the link object embedded within the specified cell in a table object.
    #
    # @param row [Integer] row number
    # @param column [Integer] column number
    # @example
    #   list_table.click_table_cell_link(3, 1)
    #
    def click_table_cell_link(row, column)
      row_count = get_row_count
      raise "Row #{row} exceeds number of rows (#{row_count}) in table #{@locator}" if row > row_count
      column_count = get_column_count
      raise "Column #{column} exceeds number of columns (#{column_count}) in table #{@locator}" if column > column_count
      set_table_cell_locator(row, column)
      saved_locator = @alt_locator
      set_alt_locator("#{@alt_locator}/a")
      set_alt_locator("#{saved_locator}/span/a") unless exists?
      # if link not present, check for text entry fields and try to dismiss by tabbing out
      unless exists?
        set_alt_locator("#{saved_locator}/input")
        set_alt_locator("#{saved_locator}/textarea") unless exists?
        send_keys(:tab) if exists?
        set_alt_locator("#{saved_locator}/a")
        set_alt_locator("#{saved_locator}/span/a") unless exists?
        send_keys(:tab) unless exists?
      end
      wait_until_exists(1)
      click
      clear_alt_locator
    end

    def get_table_row(row)
      columns = []
      row_count = get_row_count
      raise "Row #{row} exceeds number of rows (#{row_count}) in table #{@locator}" if row > row_count
      column_count = get_column_count
      (1..column_count).each do |column|
        value = ''
        set_table_cell_locator(row, column)
        saved_locator = @alt_locator
        set_alt_locator("#{saved_locator}/input")
        unless exists?
          set_alt_locator("#{saved_locator}/textarea")
          unless exists?
            set_alt_locator(saved_locator)
          end
        end
        value = get_value if exists?
        columns.push(value)
      end
      clear_alt_locator
      columns
    end

    def get_row_data(row)
      row_count = get_row_count
      raise "Row #{row} exceeds number of rows (#{row_count}) in table #{@locator}" if row > row_count
      (row > 1) ?
          set_alt_locator("#{@locator}/tbody/tr[#{row}]") :
          set_alt_locator("#{@locator}/tbody/tr")
      value = get_value if exists?
      clear_alt_locator
      value
    end

    # Return text contained in specified cell of a table object.
    #
    # @param row [Integer] row number
    # @param column [Integer] column number
    # @return [String] value of table cell
    # @example
    #   list_table.get_table_cell(4, 5)
    #
    def get_table_cell(row, column)
      row_count = get_row_count
      raise "Row #{row} exceeds number of rows (#{row_count}) in table #{@locator}" if row > row_count
      column_count = get_column_count
      raise "Column #{column} exceeds number of columns (#{column_count}) in table #{@locator}" if column > column_count
      set_table_cell_locator(row, column)
      saved_locator = @alt_locator
      set_alt_locator("#{saved_locator}/input")
      unless exists?
        set_alt_locator("#{saved_locator}/textarea")
        unless exists?
          set_alt_locator(saved_locator)
        end
      end
      value = get_value if exists?
      clear_alt_locator
      value
    end

    def verify_table_cell(row, column, expected, enqueue = false)
      actual = get_table_cell(row, column)
      enqueue ?
          ExceptionQueue.enqueue_assert_equal(expected.strip, actual.strip, "Expected #{@locator} row #{row}/column #{column}") :
          assert_equal(expected.strip, actual.strip, "Expected #{@locator} row #{row}/column #{column} to display '#{expected}' but found '#{actual}'")
    end

    # Set the value of the specified cell in a table object.
    #
    # @param row [Integer] row number
    # @param column [Integer] column number
    # @param value [String] text to set
    # @example
    #   list_table.set_table_cell(3, 1, 'Ontario')
    #
    def set_table_cell(row, column, value)
      row_count = get_row_count
      raise "Row #{row} exceeds number of rows (#{row_count}) in table #{@locator}" if row > row_count
      # column_count = get_column_count
      # raise "Column #{column} exceeds number of columns (#{column_count}) in table #{@locator}" if column > column_count
      set_table_cell_locator(row, column)
      click if exists?
      saved_locator = @alt_locator
      set_alt_locator("#{saved_locator}/input")
      set_alt_locator("#{saved_locator}/textarea") unless exists?
      set(value)
      clear_alt_locator
    end

    def find_in_table_row(row, search_value)
      (1..get_column_count).each do |column|
        return column if get_table_cell(row, column) == search_value
      end
      nil
    end

    def find_in_table_column(column, search_value)
      (1..get_row_count).each do |row|
        return row if get_table_cell(row, column) == search_value
      end
      nil
    end

    def populate_table_row(row, data)
      wait_until_exists(2)
      data.each do | column, data_param |
        unless data_param.blank?
          if data_param == '!DELETE'
            set_table_cell(row, column, '')
          else
            set_table_cell(row, column, data_param)
          end
        end
      end
    end

    def click_header_column(column)
      column_count = get_column_count
      raise "Column #{column} exceeds number of columns (#{column_count}) in table header #{@locator}" if column > column_count
      (column > 1) ?
          set_alt_locator("#{@locator}/thead/tr/th[#{column}]") :
          set_alt_locator("#{@locator}/thead/tr/th")
      click
      clear_alt_locator
    end

    def get_header_column(column)
      column_count = get_column_count
      raise "Column #{column} exceeds number of columns (#{column_count}) in table header #{@locator}" if column > column_count
      (column > 1) ?
          set_alt_locator("#{@locator}/thead/tr/th[#{column}]") :
          set_alt_locator("#{@locator}/thead/tr/th")
      value = get_value
      clear_alt_locator
      value
    end

    def get_header_columns
      columns = []
      column_count = get_column_count
      (1..column_count).each do |column|
        (column > 1) ?
            set_alt_locator("#{@locator}/thead/tr/th[#{column}]") :
            set_alt_locator("#{@locator}/thead/tr/th")
        columns.push(get_value)
      end
      clear_alt_locator
      columns
    end

    private

    def set_table_cell_locator(row, column)
      row_spec = "#{@locator}/tbody/tr"
      row_spec = "#{row_spec}[#{row}]" if row > 1
      column_spec = "/td[#{column}]"
      set_alt_locator("#{row_spec}#{column_spec}")
    end
  end
end
