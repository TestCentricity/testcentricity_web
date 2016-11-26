module TestCentricity
  class Table < UIElement
    attr_accessor :table_body
    attr_accessor :table_section
    attr_accessor :table_row
    attr_accessor :table_column
    attr_accessor :table_header
    attr_accessor :header_row
    attr_accessor :header_column
    attr_accessor :tree_expand
    attr_accessor :tree_collapse

    def initialize(name, parent, locator, context)
      super
      @type = :table

      table_spec = { :table_body    => 'tbody',
                     :table_section => nil,
                     :table_row     => 'tr',
                     :table_column  => 'td',
                     :table_header  => 'thead',
                     :header_row    => 'tr',
                     :header_column => 'th',
                     :tree_expand   => "div/div[contains(@class, 'tree-plus treeclick')]",
                     :tree_collapse => "div/div[contains(@class, 'tree-minus treeclick')]" }
      define_table_elements(table_spec)
    end

    def define_table_elements(element_spec)
      element_spec.each do |element, value|
        case element
        when :table_body
          @table_body = value
        when :table_section
          @table_section = value
        when :table_row
          @table_row = value
        when :table_column
          @table_column = value
        when :table_header
          @table_header = value
        when :header_row
          @header_row = value
        when :header_column
          @header_column = value
        when :tree_expand
          @tree_expand = value
        when :tree_collapse
          @tree_collapse = value
        end
      end
    end

    # Return number of rows in a table object.
    #
    # @return [Integer]
    # @example
    #   num_rows = list_table.get_row_count
    #
    def get_row_count
      wait_until_exists(5)
      if @table_section.nil?
        page.all(:xpath, "#{@locator}/#{@table_body}/#{@table_row}", :visible => :all).count
      else
        page.all(:xpath, "#{@locator}/#{@table_body}/#{@table_section}", :visible => :all).count
      end
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
        page.all(:xpath, "#{@locator}/#{@table_header}/#{@header_row}/#{@header_column}", :visible => :all).count
      else
        if @table_section.nil?
          (row_count == 1) ?
              page.all(:xpath, "#{@locator}/#{@table_body}/#{@table_row}/#{@table_column}", :visible => :all).count :
              page.all(:xpath, "#{@locator}/#{@table_body}/#{@table_row}[2]/#{@table_column}", :visible => :all).count
        else
          (row_count == 1) ?
              page.all(:xpath, "#{@locator}/#{@table_body}/#{@table_section}/#{@table_row}/#{@table_column}", :visible => :all).count :
              page.all(:xpath, "#{@locator}/#{@table_body}/#{@table_section}[2]/#{@table_row}/#{@table_column}", :visible => :all).count
        end
      end
    end

    # Hover over the specified cell in a table object.
    #
    # @param row [Integer] row number
    # @param column [Integer] column number
    # @example
    #   list_table.hover_table_cell(2, 6)
    #
    def hover_table_cell(row, column)
      row_count = get_row_count
      raise "Row #{row} exceeds number of rows (#{row_count}) in table #{object_ref_message}" if row > row_count
      column_count = get_column_count
      raise "Column #{column} exceeds number of columns (#{column_count}) in table #{object_ref_message}" if column > column_count
      set_table_cell_locator(row, column)
      hover
      clear_alt_locator
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
      raise "Row #{row} exceeds number of rows (#{row_count}) in table #{object_ref_message}" if row > row_count
      column_count = get_column_count
      raise "Column #{column} exceeds number of columns (#{column_count}) in table #{object_ref_message}" if column > column_count
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
      raise "Row #{row} exceeds number of rows (#{row_count}) in table #{object_ref_message}" if row > row_count
      column_count = get_column_count
      raise "Column #{column} exceeds number of columns (#{column_count}) in table #{object_ref_message}" if column > column_count
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
      raise "Row #{row} exceeds number of rows (#{row_count}) in table #{object_ref_message}" if row > row_count
      column_count = get_column_count
      raise "Column #{column} exceeds number of columns (#{column_count}) in table #{object_ref_message}" if column > column_count
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
      raise "Row #{row} exceeds number of rows (#{row_count}) in table #{object_ref_message}" if row > row_count
      column_count = get_column_count
      (1..column_count).each do |column|
        value = ''
        set_table_cell_locator(row, column)
        saved_locator = @alt_locator
        set_alt_locator("#{saved_locator}/input")
        unless exists?
          set_alt_locator("#{saved_locator}/textarea")
          set_alt_locator(saved_locator) unless exists?
        end
        value = get_value if exists?
        columns.push(value)
      end
      clear_alt_locator
      columns
    end

    def get_row_data(row)
      row_count = get_row_count
      raise "Row #{row} exceeds number of rows (#{row_count}) in table #{object_ref_message}" if row > row_count
      (row > 1) ?
          set_alt_locator("#{@locator}/#{@table_body}/#{@table_row}[#{row}]") :
          set_alt_locator("#{@locator}/#{@table_body}/#{@table_row}")
      value = get_value if exists?
      clear_alt_locator
      value
    end

    def get_table_column(column)
      rows = []
      column_count = get_column_count
      raise "Column #{column} exceeds number of columns (#{column_count}) in table #{object_ref_message}" if column > column_count
      row_count = get_row_count
      (1..row_count).each do |row|
        value = ''
        set_table_cell_locator(row, column)
        saved_locator = @alt_locator
        set_alt_locator("#{saved_locator}/input")
        unless exists?
          set_alt_locator("#{saved_locator}/textarea")
          set_alt_locator(saved_locator) unless exists?
        end
        value = get_value if exists?
        rows.push(value)
      end
      clear_alt_locator
      rows
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
      raise "Row #{row} exceeds number of rows (#{row_count}) in table #{object_ref_message}" if row > row_count
      column_count = get_column_count
      raise "Column #{column} exceeds number of columns (#{column_count}) in table #{object_ref_message}" if column > column_count
      set_table_cell_locator(row, column)
      saved_locator = @alt_locator
      set_alt_locator("#{saved_locator}/input")
      unless exists?
        set_alt_locator("#{saved_locator}/textarea")
        set_alt_locator(saved_locator) unless exists?
      end
      if exists?
        value = get_value
      else
        puts "Could not find table cell at #{@alt_locator}"
        value = ''
      end
      clear_alt_locator
      value
    end

    def verify_table_cell(row, column, expected, enqueue = false)
      actual = get_table_cell(row, column)
      enqueue ?
          ExceptionQueue.enqueue_assert_equal(expected.strip, actual.strip, "Expected table #{object_ref_message} row #{row}/column #{column}") :
          assert_equal(expected.strip, actual.strip, "Expected table #{object_ref_message} row #{row}/column #{column} to display '#{expected}' but found '#{actual}'")
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
      raise "Row #{row} exceeds number of rows (#{row_count}) in table #{object_ref_message}" if row > row_count
      find_table_cell(row, column)
      find_table_cell(row, column) unless exists?
      set(value)
      clear_alt_locator
    end

    def get_cell_attribute(row, column, attrib)
      row_count = get_row_count
      raise "Row #{row} exceeds number of rows (#{row_count}) in table #{object_ref_message}" if row > row_count
      column_count = get_column_count
      raise "Column #{column} exceeds number of columns (#{column_count}) in table #{object_ref_message}" if column > column_count
      set_table_cell_locator(row, column)
      result = get_native_attribute(attrib)
      clear_alt_locator
      result
    end

    def get_row_attribute(row, attrib)
      row_count = get_row_count
      raise "Row #{row} exceeds number of rows (#{row_count}) in table #{object_ref_message}" if row > row_count
      (row > 1) ?
          set_alt_locator("#{@locator}/#{@table_body}/#{@table_row}[#{row}]") :
          set_alt_locator("#{@locator}/#{@table_body}/#{@table_row}")
      result = get_native_attribute(attrib)
      clear_alt_locator
      result
    end

    def find_row_attribute(attrib, search_value)
      (1..get_row_count).each do |row|
        return row if get_row_attribute(row, attrib) == search_value
      end
      nil
    end

    # Search for the specified text value in the specified row of the table object.
    # Returns the number of the first column that contains the search value.
    #
    # @param row [Integer] row nummber
    # @param search_value [String] value to be searched for
    # @return [Integer] column number of table cell that contains search value
    # @example
    #   bom_table.find_in_table_row(4, 'High-speed Framus bolts')
    #
    def find_in_table_row(row, search_value)
      (1..get_column_count).each do |column|
        return column if get_table_cell(row, column) == search_value
      end
      nil
    end

    # Search for the specified text value in the specified column of the table object.
    # Returns the number of the first row that contains the search value.
    #
    # @param column [Integer] column nummber
    # @param search_value [String] value to be searched for
    # @return [Integer] row number of table cell that contains search value
    # @example
    #   playlist_table.find_in_table_column(1, 'Ashes to Ashes')
    #
    def find_in_table_column(column, search_value)
      (1..get_row_count).each do |row|
        return row if get_table_cell(row, column) == search_value
      end
      nil
    end

    # Populate the specified row of this table object with the associated data from a Hash passed as an
    # argument. Data values must be in the form of a String for textfield and select list controls. For checkbox
    # and radio buttons, data must either be a Boolean or a String that evaluates to a Boolean value (Yes, No, 1,
    # 0, true, false)
    #
    # @param data [Hash] column numbers and associated data to be entered
    # @example
    #   data = { 1 => 'Dr.',
    #            2 => 'Evangeline',
    #            3 => 'Devereaux',
    #            4 => 'MD',
    #            5 => 'Family Practice'
    #          }
    #   clinicians_table.populate_table_row(3, data)
    #
    def populate_table_row(row, data)
      wait_until_exists(2)
      data.each do |column, data_param|
        unless data_param.blank?
          if data_param == '!DELETE'
            set_table_cell(row, column, '')
          else
            set_table_cell(row, column, data_param)
          end
        end
      end
    end

    # Click in the specified column header in a table object.
    #
    # @param column [Integer] column number
    # @example
    #   list_table.click_header_column(3)
    #
    def click_header_column(column)
      column_count = get_column_count
      raise "Column #{column} exceeds number of columns (#{column_count}) in table header #{object_ref_message}" if column > column_count
      set_alt_locator("#{@locator}//#{@table_header}/#{@header_row}/#{@header_column}[#{column}]")
      click if exists?
      clear_alt_locator
    end

    def get_header_column(column)
      column_count = get_column_count
      raise "Column #{column} exceeds number of columns (#{column_count}) in table header #{object_ref_message}" if column > column_count
      set_alt_locator("#{@locator}//#{@table_header}/#{@header_row}/#{@header_column}[#{column}]")
      value = get_value(:all) if exists?(:all)
      clear_alt_locator
      value
    end

    def get_header_columns
      columns = []
      column_count = get_column_count
      (1..column_count).each do |column|
        set_alt_locator("#{@locator}//#{@table_header}/#{@header_row}/#{@header_column}[#{column}]")
        columns.push(get_value(:all)) if exists?(:all)
      end
      clear_alt_locator
      columns
    end

    def is_table_row_expanded?(row, column)
      row_count = get_row_count
      raise "Row #{row} exceeds number of rows (#{row_count}) in table #{object_ref_message}" if row > row_count
      column_count = get_column_count
      raise "Column #{column} exceeds number of columns (#{column_count}) in table #{object_ref_message}" if column > column_count
      set_table_cell_locator(row, column)
      set_alt_locator("#{@alt_locator}/#{@tree_expand}")
      expanded = true
      expanded = false if exists?
      clear_alt_locator
      expanded
    end

    def expand_table_row(row, column)
      unless is_table_row_expanded?(row, column)
        set_table_cell_locator(row, column)
        set_alt_locator("#{@alt_locator}/#{@tree_expand}")
        click if exists?
        clear_alt_locator
      end
    end

    def collapse_table_row(row, column)
      if is_table_row_expanded?(row, column)
        set_table_cell_locator(row, column)
        set_alt_locator("#{@alt_locator}/#{@tree_collapse}")
        click if exists?
        clear_alt_locator
      end
    end

    def expand_all_table_rows(column)
      row_count = get_row_count
      column_count = get_column_count
      raise "Column #{column} exceeds number of columns (#{column_count}) in table #{object_ref_message}" if column > column_count
      row_count.downto(1) do |row|
        expand_table_row(row, column)
      end
    end

    private

    def set_table_cell_locator(row, column)
      if @table_section.nil?
        row_spec = "#{@locator}/#{@table_body}/#{@table_row}"
        row_spec = "#{row_spec}[#{row}]"
      else
        row_spec = "#{@locator}/#{@table_body}/#{@table_section}"
        row_spec = "#{row_spec}[#{row}]/#{@table_row}[1]"
      end
      column_spec = "/#{@table_column}[#{column}]"
      set_alt_locator("#{row_spec}#{column_spec}")
    end

    def find_table_cell(row, column)
      set_table_cell_locator(row, column)
      if exists?
        click
      else
        puts "Could not find table cell at #{@alt_locator}"
      end
      saved_locator = @alt_locator
      set_alt_locator("#{saved_locator}/input")
      set_alt_locator("#{saved_locator}/textarea") unless exists?
    end
  end
end
