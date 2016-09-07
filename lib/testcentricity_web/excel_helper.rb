require 'time'
require 'chronic'
require 'faker'
require 'spreadsheet'


module TestCentricity
  class ExcelData
    @mru = {}

    def self.worksheet_exists?(file, sheet)
      exists = false
      work_book  = Spreadsheet.open file
      worksheets = work_book.worksheets
      worksheets.each do |worksheet|
        if worksheet.name == sheet
          exists = true
          break
        end
      end
      exists
    end

    def self.rowspec_exists?(file, sheet, rowspec)
      exists = false
      if worksheet_exists?(file, sheet)
        work_book  = Spreadsheet.open file
        work_sheet  = work_book.worksheet sheet
        # get column headings from row 0 of worksheet
        headings = work_sheet.row(0)
        # if rowspec is a string then we have to find a matching row name
        if rowspec.is_a? String
          column_number = 0
          exists = false
          headings.each do |heading|
            if heading == 'ROW_NAME'
              exists = true
              break
            end
            column_number += 1
          end
          raise "Could not find a column named ROW_NAME in worksheet #{sheet}" unless exists
          # find first cell in ROW_NAME column containing a string that matches the rowspec parameter
          exists = false
          row_number = 0
          work_sheet.each do |row|
            if row[column_number] == rowspec
              exists = true
              break
            end
            row_number += 1
          end
        end
      end
      exists
    end

    def self.read_row_from_pool(file, sheet, rowspec, columns = nil)
      work_book  = Spreadsheet.open file
      work_sheet = work_book.worksheet sheet

      pool_spec_key = "#{sheet}:#{rowspec}"
      if @mru.key?(pool_spec_key)
        pool_spec = @mru[pool_spec_key]
        row_start = pool_spec[:start_row]
        row_end   = pool_spec[:num_rows]
        pool_rows = (row_start..row_start + row_end - 1).to_a
        mru_rows  = pool_spec[:used_rows]
        new_row   = pool_rows.sample.to_i
        if mru_rows.size == pool_spec[:num_rows]
          mru_rows = [new_row]
        else
          while mru_rows.include?(new_row)
            new_row = pool_rows.sample.to_i
          end
          mru_rows.push(new_row)
          mru_rows.sort!
        end

        pool_spec = {
            :start_row => row_start,
            :num_rows  => row_end,
            :used_rows => mru_rows
        }
      else
        # get column headings from row 0 of worksheet
        headings      = work_sheet.row(0)
        column_number = 0
        found         = false
        headings.each do |heading|
          if heading == 'ROW_NAME'
            found = true
            break
          end
          column_number += 1
        end
        raise "Could not find a column named ROW_NAME in worksheet #{sheet}" unless found
        # find cell(s) in ROW_NAME column containing a string that matches the rowspec parameter
        found      = []
        row_number = 0
        work_sheet.each do |row|
          if row[column_number] == rowspec
            found.push(row_number)
          elsif !found.empty?
            break
          end
          row_number += 1
        end
        raise "Could not find a row named '#{rowspec}' in worksheet #{sheet}" if found.empty?

        new_row   = found.sample.to_i
        pool_spec = {
            :start_row => found[0],
            :num_rows  => found.size,
            :used_rows => [new_row]
        }
      end
      @mru[pool_spec_key] = pool_spec

      read_row_data(file, sheet, new_row, columns)
    end

    def self.read_row_data(file, sheet, rowspec, columns = nil)
      work_book  = Spreadsheet.open file
      work_sheet  = work_book.worksheet sheet
      # get column headings from row 0 of worksheet
      headings = work_sheet.row(0)
      # if rowspec is a string then we have to find a matching row name
      if rowspec.is_a? String
        column_number = 0
        found = false
        headings.each do |heading|
          if heading == 'ROW_NAME'
            found = true
            break
          end
          column_number += 1
        end
        raise "Could not find a column named ROW_NAME in worksheet #{sheet}" unless found
        # find first cell in ROW_NAME column containing a string that matches the rowspec parameter
        found = false
        row_number = 0
        work_sheet.each do |row|
          if row[column_number] == rowspec
            found = true
            break
          end
          row_number += 1
        end
        raise "Could not find a row named '#{rowspec}' in worksheet #{sheet}" unless found
        data = work_sheet.row(row_number)
        # if rowspec is a number then ensure that it doesn't exceed the number of available rows
      elsif rowspec.is_a? Numeric
        raise "Row # #{rowspec} is greater than number of rows in worksheet #{sheet}" if rowspec > work_sheet.last_row_index
        data = work_sheet.row(rowspec)
      end

      # if no columns have been specified, return all columns
      columns = headings if columns == nil
      # create results hash table
      result = Hash.new
      columns.each do |column|
        column_number = 0
        found = false
        headings.each do |heading|
          if column == heading
            value = data[column_number].to_s
            value = calculate_dynamic_value(value) if value.start_with? 'eval!'
            result[column] = value
            found = true
            break
          end
          column_number += 1
        end
        raise "Could not find a column named '#{column}' in worksheet #{sheet}" unless found
      end
      result
    end

    def self.read_range_data(file, sheet, rangespec)
      work_book  = Spreadsheet.open file
      work_sheet = work_book.worksheet sheet
      # get column headings from row 0 of worksheet
      headings = work_sheet.row(0)
      column_number = 0
      found = false
      headings.each do |heading|
        if heading == 'ROW_NAME'
          found = true
          break
        end
        column_number += 1
      end
      raise "Could not find a column named ROW_NAME in worksheet #{sheet}" unless found
      # find cell(s) in ROW_NAME column containing a string that matches the rangespec parameter
      found      = []
      row_number = 0
      work_sheet.each do |row|
        if row[column_number] == rangespec
          found.push(row_number)
        elsif !found.empty?
          break
        end
        row_number += 1
      end
      raise "Could not find a row named '#{rangespec}' in worksheet #{sheet}" if found.empty?

      result = []
      found.each do |row|
        result.push(read_row_data(file, sheet, row))
      end
      result
    end

    private

    def self.calculate_dynamic_value(value)
      test_value = value.split('!', 2)
      parameter = test_value[1].split('.', 2)
      case parameter[0]
      when 'Address', 'Business', 'Code', 'Color', 'Commerce', 'Company', 'Crypto', 'File', 'Hacker', 'Hipster', 'Internet', 'Lorem', 'Name', 'Number', 'PhoneNumber'
        result = eval("Faker::#{parameter[0]}.#{parameter[1]}")
      when 'Date'
        result = eval("Chronic.parse('#{parameter[1]}')")
      when 'FormattedDate', 'FormatDate'
        date_time_params = parameter[1].split(" format! ", 2)
        date_time = eval("Chronic.parse('#{date_time_params[0].strip}')")
        result = date_time.to_s.format_date_time("#{date_time_params[1].strip}")
      else
        result = eval(test_value[1])
      end
      result.to_s
    end
  end
end
