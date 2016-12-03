require 'yaml'
require 'json'


module TestCentricity

  XL_PRIMARY_DATA_PATH ||= 'features/test_data/'
  XL_PRIMARY_DATA_FILE ||= "#{XL_PRIMARY_DATA_PATH}data.xls"


  class DataObject
    attr_accessor :current
    attr_accessor :context
    attr_accessor :hash_table

    def initialize(data)
      @hash_table = data
    end

    # @deprecated Please use {#current=} instead
    def self.set_current(current)
      warn "[DEPRECATION] 'TestCentricity::DataObject.set_current' is deprecated.  Please use 'current=' instead."
      @current = current
    end

    def self.current
      @current
    end

    def self.current=(current)
      @current = current
    end
  end


  class DataSource
    attr_accessor :current

    def read_yaml_node_data(file_name, node_name)
      data = YAML.load_file("#{XL_PRIMARY_DATA_PATH}#{file_name}")
      data[node_name]
    end

    def read_json_node_data(file_name, node_name)
      raw_data = File.read("#{XL_PRIMARY_DATA_PATH}#{file_name}")
      data = JSON.parse(raw_data)
      data[node_name]
    end
  end


  class ExcelDataSource < TestCentricity::DataSource
    def pick_excel_data_source(sheet, row_spec)
      if ENV['TEST_ENVIRONMENT']
        environment = ENV['TEST_ENVIRONMENT']
        data_file = "#{XL_PRIMARY_DATA_PATH}#{environment}_data.xls"
        data_file = XL_PRIMARY_DATA_FILE unless ExcelData.rowspec_exists?(data_file, sheet, row_spec)
      else
        data_file = XL_PRIMARY_DATA_FILE
      end
      data_file
    end

    def read_excel_row_data(sheet, row_name, parallel = false)
      parallel == :parallel && ENV['PARALLEL'] ? row_spec = "#{row_name}#{ENV['TEST_ENV_NUMBER']}" : row_spec = row_name
      ExcelData.read_row_data(pick_excel_data_source(sheet, row_spec), sheet, row_spec)
    end

    def read_excel_pool_data(sheet, row_name, parallel = false)
      parallel == :parallel && ENV['PARALLEL'] ? row_spec = "#{row_name}#{ENV['TEST_ENV_NUMBER']}" : row_spec = row_name
      ExcelData.read_row_from_pool(pick_excel_data_source(sheet, row_name), sheet, row_spec)
    end

    def read_excel_range_data(sheet, range_name)
      ExcelData.read_range_data(pick_excel_data_source(sheet, range_name), sheet, range_name)
    end
  end
end
