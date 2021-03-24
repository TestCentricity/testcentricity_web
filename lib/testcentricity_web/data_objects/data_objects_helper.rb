require 'yaml'
require 'json'
require 'virtus'


module TestCentricity

  PRIMARY_DATA_PATH ||= 'features/test_data/'
  XL_PRIMARY_DATA_FILE ||= "#{PRIMARY_DATA_PATH}data.xls"


  class DataObject
    attr_accessor :current
    attr_accessor :context
    attr_accessor :hash_table

    def initialize(data)
      @hash_table = data
    end

    def self.current
      @current
    end

    def self.current=(current)
      @current = current
    end
  end


  class DataPresenter
    include Virtus.model

    attr_accessor :current
    attr_accessor :context

    def initialize(data)
      self.attributes = data
    end

    def self.current
      @current
    end

    def self.current=(current)
      @current = current
    end

    def to_hash(node_name = nil)
      data = {}
      if node_name.nil?
        data = { class: self.class.name, attributes: self.attributes }
      else
        data[node_name] = { class: self.class.name, attributes: self.attributes }
      end
      data
    end

    def to_yaml(node_name = nil)
      data = to_hash(node_name)
      data.to_yaml
    end

    def write_yaml_data(file_name, mode, node_name = nil)
      File.open(file_name, mode) { |file| file.write(to_yaml(node_name)) }
    end

    def to_json(node_name = nil)
      data = to_hash(node_name)
      data.to_json
    end

    def write_json_data(file_name, mode, node_name = nil)
      File.open(file_name, mode) { |file| file.write(to_json(node_name)) }
    end
  end


  class DataSource
    attr_accessor :file_path
    attr_accessor :node

    def read_yaml_node_data(file_name, node_name)
      @file_path = "#{PRIMARY_DATA_PATH}#{file_name}"
      @node = node_name
      data = YAML.load_file(@file_path)
      data[node_name]
    end

    def write_yaml_node_data(file_name, node_name, node_data)
      data = read_yaml_node_data(file_name, node_name)
      data[node_name] = node_data
      File.write(@file_path, data.to_yaml)
    end

    def read_json_node_data(file_name, node_name)
      @file_path = "#{PRIMARY_DATA_PATH}#{file_name}"
      @node = node_name
      raw_data = File.read(@file_path)
      data = JSON.parse(raw_data)
      data[node_name]
    end

    def write_json_node_data(file_name, node_name, node_data)
      data = read_json_node_data(file_name, node_name)
      data[node_name] = node_data
      File.write(@file_path, data.to_json)
    end
  end


  class ExcelDataSource < TestCentricity::DataSource
    attr_accessor :worksheet
    attr_accessor :row_spec

    def pick_excel_data_source(sheet, row_spec)
      @worksheet = sheet
      if ENV['TEST_ENVIRONMENT']
        environment = ENV['TEST_ENVIRONMENT']
        data_file = "#{PRIMARY_DATA_PATH}#{environment}_data.xls"
        data_file = XL_PRIMARY_DATA_FILE unless ExcelData.row_spec_exists?(data_file, @worksheet, row_spec)
      else
        data_file = XL_PRIMARY_DATA_FILE
      end
      @file_path = data_file
      data_file
    end

    def read_excel_row_data(sheet, row_name, parallel = false)
      @row_spec = parallel == :parallel && ENV['PARALLEL'] ? "#{row_name}#{ENV['TEST_ENV_NUMBER']}" : row_name
      ExcelData.read_row_data(pick_excel_data_source(sheet, @row_spec), sheet, @row_spec)
    end

    def read_excel_pool_data(sheet, row_name, parallel = false)
      @row_spec = parallel == :parallel && ENV['PARALLEL'] ? "#{row_name}#{ENV['TEST_ENV_NUMBER']}" : row_name
      ExcelData.read_row_from_pool(pick_excel_data_source(sheet, row_name), sheet, @row_spec)
    end

    def read_excel_range_data(sheet, range_name)
      @row_spec = range_name
      ExcelData.read_range_data(pick_excel_data_source(sheet, range_name), sheet, range_name)
    end

    def write_excel_row_data(sheet, row_name, row_data, parallel = false)
      @row_spec = parallel == :parallel && ENV['PARALLEL'] ? "#{row_name}#{ENV['TEST_ENV_NUMBER']}" : row_name
      ExcelData.write_row_data(pick_excel_data_source(sheet, @row_spec), sheet, @row_spec, row_data)
    end
  end
end
