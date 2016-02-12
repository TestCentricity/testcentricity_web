require 'capybara/cucumber'
require 'rspec/expectations'

module TestCentricity
  class DataObject
    attr_accessor :current
    attr_accessor :context
    attr_accessor :hash_table

    def initialize(data)
      @hash_table = data
    end

    def self.set_current(current)
      @current = current
    end

    def self.current
      @current
    end
  end


  class DataSource
    attr_accessor :current

    def pick_excel_data_source(sheet, row_name)
      data_file = Excel_Data.get_environment_data_file
      data_file = XL_PRIMARY_DATA_FILE unless Excel_Data.rowspec_exists?(data_file, sheet, row_name)
      data_file
    end

    def read_excel_row_data(sheet, row_name)
      Excel_Data.read_row_data(pick_excel_data_source(sheet, row_name), sheet, row_name)
    end

    def read_excel_pool_data(sheet, row_name)
      Excel_Data.read_row_from_pool(pick_excel_data_source(sheet, row_name), sheet, row_name)
    end
  end
end
