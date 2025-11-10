require 'yaml'
require 'json'
require 'virtus'
require 'time'
require 'chronic'
require 'faker'


module TestCentricity

  PRIMARY_DATA_PATH ||= 'config/test_data/'
  PRIMARY_DATA_FILE ||= "#{PRIMARY_DATA_PATH}data."
  YML_PRIMARY_DATA_FILE  ||= "#{PRIMARY_DATA_FILE}yml"
  JSON_PRIMARY_DATA_FILE ||= "#{PRIMARY_DATA_FILE}json"


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
      self.attributes = data unless data.nil?
    end

    def self.current
      @current
    end

    def self.current=(current)
      @current = current
    end
  end


# :nocov:
  class DataSource
    attr_accessor :file_path
    attr_accessor :node

    def read_yaml_node_data(file_name, node_name)
      @file_path = "#{PRIMARY_DATA_PATH}#{file_name}"
      @node = node_name
      data = YAML.load_file(@file_path)
      data[node_name]
    end

    def read_json_node_data(file_name, node_name)
      @file_path = "#{PRIMARY_DATA_PATH}#{file_name}"
      @node = node_name
      raw_data = File.read(@file_path)
      data = JSON.parse(raw_data)
      data[node_name]
    end

    private

    def self.calculate_dynamic_value(value)
      test_value = value.split('!', 2)
      parameter = test_value[1].split('.', 2)
      result = case parameter[0]
               when 'Date'
                 Chronic.parse(parameter[1])
               when 'FormattedDate', 'FormatDate'
                 date_time_params = parameter[1].split(' format! ', 2)
                 date_time = Chronic.parse(date_time_params[0].strip)
                 date_time.to_s.format_date_time("#{date_time_params[1].strip}")
               else
                 if Faker.constants.include?(parameter[0].to_sym)
                   eval("Faker::#{parameter[0]}.#{parameter[1]}")
                 else
                   eval(test_value[1])
                 end
               end
      result.to_s
    end
    # :nocov:
  end
end
