module TestCentricity

  XL_PRIMARY_DATA_PATH  ||= 'features/test_data/'
  XL_PRIMARY_DATA_FILE  ||= "#{XL_PRIMARY_DATA_PATH}data.xls"


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

    def get_environment_data_file
      environment = ENV['TEST_ENVIRONMENT']
      "#{XL_PRIMARY_DATA_PATH}#{environment}_data.xls"
    end

    def pick_excel_data_source(sheet, row_name)
      data_file = get_environment_data_file
      data_file = XL_PRIMARY_DATA_FILE unless ExcelData.rowspec_exists?(data_file, sheet, row_name)
      data_file
    end

    def read_excel_row_data(sheet, row_name)
      ExcelData.read_row_data(pick_excel_data_source(sheet, row_name), sheet, row_name)
    end

    def read_excel_pool_data(sheet, row_name)
      ExcelData.read_row_from_pool(pick_excel_data_source(sheet, row_name), sheet, row_name)
    end

    def read_excel_range_data(sheet, range_name)
      ExcelData.read_range_data(pick_excel_data_source(sheet, range_name), sheet, range_name)
    end
  end
end
