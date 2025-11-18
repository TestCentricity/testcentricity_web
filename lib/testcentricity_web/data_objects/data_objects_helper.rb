require 'active_support'
require 'active_support/core_ext/hash'
require 'chronic'
require 'faker'
require 'json'
require 'rexml/document'
require 'smarter_csv'
require 'time'
require 'virtus'
require 'yaml'


module TestCentricity

  PRIMARY_DATA_PATH ||= 'config/test_data/'
  SECONDARY_DATA_PATH ||= 'config/data/'
  PRIMARY_DATA_FILE ||= "#{PRIMARY_DATA_PATH}data."
  YML_PRIMARY_DATA_FILE  ||= "#{PRIMARY_DATA_FILE}yml"
  JSON_PRIMARY_DATA_FILE ||= "#{PRIMARY_DATA_FILE}json"


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
    attr_accessor :file_extension

    def read_file(file_name, key = nil, node_name = nil, options = nil)
      # check to see if full file path was specified
      if File.exist?(file_name)
        @file_path = file_name
      else
        # construct the full file path to the file to be read
        @file_path = "#{PRIMARY_DATA_PATH}#{file_name}"
        unless File.exist?(@file_path)
          @file_path = "#{SECONDARY_DATA_PATH}#{file_name}"
          raise "File #{file_name} not found in Primary or Secondary folders in config folder" unless File.exist?(@file_path)
        end
      end
      # determine file type and read in data from file
      @file_extension = File.extname(file_name)
      data = case @file_extension
             when '.yml'
               YAML.load_file(@file_path)
             when'.json'
               JSON.parse(File.read(@file_path))
             when '.xml'
               xml_data = File.read(@file_path)
               Hash.from_xml(xml_data)
             when '.csv'
               if options
                 SmarterCSV.process(@file_path, options)
               else
                 SmarterCSV.process(@file_path)
               end
             else
               raise "#{file_name} is not a supported file type"
             end
      # return data if sourced from a .csv file
      return data if @file_extension == '.csv'

      # read data from specified key and/or node
      result = if key
                 raise "Key #{key} not found" unless data.key?(key)

                 if node_name
                   raise "Node #{node_name} not found" unless data[key].key?(node_name)

                   data[key][node_name]
                 else
                   data[key]
                 end
               else
                 data
               end
      self.class.send(:process_data, result, options)
    end

    private

    def self.process_data(data, options)
      # calculate dynamic values if any are specified
      if data.is_a?(Hash)
        data.each do |key, value|
          data[key] = calculate_dynamic_value(value) if value.to_s.start_with?('eval!')
        end
      end
      return data unless options

      # convert keys to symbols if :keys_as_symbols is true in options
      if options.key?(:keys_as_symbols) && options[:keys_as_symbols]
        data.transform_keys!(&:to_sym)
      end
      # convert values if :value_converters are specified in options
      if options.key?(:value_converters)
        map_values(data, options[:value_converters])
      else
        data
      end
    end

    def self.map_values(data, value_converters)
      data.each_with_object({}) do |(k, v), new_hash|
        converter = value_converters[k]
        v = converter.convert(v) if converter
        new_hash[k] = v
      end
    end

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


# perform conversion of String to Boolean when reading data from .csv or .xml files
class ToBoolean
  def self.convert(value)
    value.to_bool unless value.nil?
  end
end


# perform conversion of Integer to String when reading data from .csv or .xml files
class ToString
  def self.convert(value)
    if value.is_a? Integer
      value.to_s
    else
      value
    end
  end
end


# perform conversion of String to Integer when reading data from .csv or .xml files
class ToInteger
  def self.convert(value)
    if value.is_a? Integer
      value
    else
      if value.is_int?
        value.to_i
      else
        value
      end
    end
  end
end


# perform conversion of String to Float when reading data from .csv or .xml files
class ToFloat
  def self.convert(value)
    if value.is_a? Float
      value
    else
      if value.is_float?
        value.to_f
      else
        value
      end
    end
  end
end
