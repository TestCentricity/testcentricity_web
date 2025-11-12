require 'yaml'
require 'json'
require 'virtus'
require 'time'
require 'chronic'
require 'faker'


module TestCentricity

  PRIMARY_DATA_PATH ||= 'config/test_data/'
  SECONDARY_DATA_PATH ||= 'config/data/'
  PRIMARY_DATA_FILE ||= "#{PRIMARY_DATA_PATH}data."
  YML_PRIMARY_DATA_FILE  ||= "#{PRIMARY_DATA_FILE}yml"
  JSON_PRIMARY_DATA_FILE ||= "#{PRIMARY_DATA_FILE}json"


  class DataObject
    attr_accessor :current
    attr_accessor :attributes

    def initialize(data)
      @attributes = data
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

    def self.current
      @current
    end

    def self.current=(current)
      @current = current
    end
  end


  class DataSource
    attr_accessor :file_path

    def read(file_name, key_name = nil, node_name = nil)
      # construct the full file path to the file to be read
      @file_path = "#{PRIMARY_DATA_PATH}#{file_name}"
      unless File.exist?(@file_path)
        @file_path = "#{SECONDARY_DATA_PATH}#{file_name}"
        raise "File #{file_name} not found in Primary or Secondary folders in config folder" unless File.exist?(@file_path)
      end
      # determine file type and read in data from file
      data = case File.extname(file_name)
             when '.yml'
               YAML.load_file(@file_path)
             when'.json'
               JSON.parse(File.read(@file_path))
             else
               raise "#{file_name} is not a supported file type"
             end
      # read data from specified key and/or node
      if key_name
        if node_name
          data[key_name][node_name]
        else
          data[key_name]
        end
      else
        data
      end
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
  end
end
