require 'spreadsheet'


module TestCentricity
  class ExcelData
    @mru = {}

    def self.worksheet_exists?(file, sheet)
      exists = false
      if File.exist?(file)
        work_book  = Spreadsheet.open(file)
        worksheets = work_book.worksheets
        worksheets.each do |worksheet|
          if worksheet.name == sheet
            exists = true
            break
          end
        end
      end
      exists
    end

    def self.row_spec_exists?(file, sheet, row_spec)
      exists = false
      if worksheet_exists?(file, sheet)
        work_book  = Spreadsheet.open(file)
        work_sheet = work_book.worksheet(sheet)
        # get column headings from row 0 of worksheet
        headings = work_sheet.row(0)
        # if row_spec is a string then we have to find a matching row name
        if row_spec.is_a? String
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
          # find first cell in ROW_NAME column containing a string that matches the row_spec parameter
          exists = false
          work_sheet.each do |row|
            if row[column_number] == row_spec
              exists = true
              break
            end
          end
        end
      end
      exists
    end

    def self.read_row_from_pool(file, sheet, row_spec, columns = nil)
      raise "File #{file} does not exists" unless File.exist?(file)
      work_book  = Spreadsheet.open(file)
      work_sheet = work_book.worksheet(sheet)

      pool_spec_key = "#{sheet}:#{row_spec}"
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
          start_row: row_start,
          num_rows:  row_end,
          used_rows: mru_rows
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
        # find cell(s) in ROW_NAME column containing a string that matches the row_spec parameter
        found      = []
        row_number = 0
        work_sheet.each do |row|
          if row[column_number] == row_spec
            found.push(row_number)
          elsif !found.empty?
            break
          end
          row_number += 1
        end
        raise "Could not find a row named '#{row_spec}' in worksheet #{sheet}" if found.empty?

        new_row   = found.sample.to_i
        pool_spec = {
          start_row: found[0],
          num_rows:  found.size,
          used_rows: [new_row]
        }
      end
      @mru[pool_spec_key] = pool_spec

      read_row_data(file, sheet, new_row, columns)
    end

    def self.read_row_data(file, sheet, row_spec, columns = nil)
      raise "File #{file} does not exists" unless File.exist?(file)
      work_book  = Spreadsheet.open(file)
      work_sheet = work_book.worksheet(sheet)
      # get column headings from row 0 of worksheet
      headings = work_sheet.row(0)
      # if row_spec is a string then we have to find a matching row name
      if row_spec.is_a? String
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
        # find first cell in ROW_NAME column containing a string that matches the row_spec parameter
        found = false
        row_number = 0
        work_sheet.each do |row|
          if row[column_number] == row_spec
            found = true
            break
          end
          row_number += 1
        end
        raise "Could not find a row named '#{row_spec}' in worksheet #{sheet}" unless found
        data = work_sheet.row(row_number)
        # if row_spec is a number then ensure that it doesn't exceed the number of available rows
      elsif row_spec.is_a? Numeric
        raise "Row # #{row_spec} is greater than number of rows in worksheet #{sheet}" if row_spec > work_sheet.last_row_index
        data = work_sheet.row(row_spec)
      end

      # if no columns have been specified, return all columns
      columns = headings if columns.nil?
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

    def self.read_range_data(file, sheet, range_spec)
      raise "File #{file} does not exists" unless File.exist?(file)
      work_book  = Spreadsheet.open(file)
      work_sheet = work_book.worksheet(sheet)
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
      # find cell(s) in ROW_NAME column containing a string that matches the range_spec parameter
      found      = []
      row_number = 0
      work_sheet.each do |row|
        if row[column_number] == range_spec
          found.push(row_number)
        elsif !found.empty?
          break
        end
        row_number += 1
      end
      raise "Could not find a row named '#{range_spec}' in worksheet #{sheet}" if found.empty?

      result = []
      found.each do |row|
        result.push(read_row_data(file, sheet, row))
      end
      result
    end

    def self.write_row_data(file, sheet, row_spec, row_data)
      raise "File #{file} does not exists" unless File.exist?(file)
      work_book  = Spreadsheet.open(file)
      work_sheet = work_book.worksheet(sheet)
      # get column headings from row 0 of worksheet
      headings = work_sheet.row(0)
      # find a matching row name
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
      # find first cell in ROW_NAME column containing a string that matches the row_spec parameter
      found = false
      row_number = 0
      work_sheet.each do |row|
        if row[column_number] == row_spec
          found = true
          break
        end
        row_number += 1
      end
      raise "Could not find a row named '#{row_spec}' in worksheet #{sheet}" unless found
      # iterate through the row_data Hash
      row_data.each do |column, value|
        column_number = 0
        found = false
        # find the column heading that matches the specified column name
        headings.each do |heading|
          if heading == column
            found = true
            break
          end
          column_number += 1
        end
        raise "Could not find a column named '#{column}' in worksheet #{sheet}" unless found
        # set the value of the specified row and column
        work_sheet.rows[row_number][column_number] = value
      end
      # iterate through all worksheets so that all worksheets are saved in new Excel document
      worksheets = work_book.worksheets
      worksheets.each do |worksheet|
        headings = worksheet.row(0)
        worksheet.rows[0][0] = headings[0]
      end
      # write all changes to new Excel document
      outfile = file.gsub(File.basename(file), 'output.xls')
      work_book.write outfile
      # delete original Excel document
      File.delete(file)
      # rename new Excel document, replacing the original
      File.rename(outfile, file)
    end
  end
end

