require 'testcentricity_web/version'
require 'testcentricity_web/browser_helper'
require 'testcentricity_web/data_objects_helper'
require 'testcentricity_web/drag_drop_helper'
require 'testcentricity_web/excel_helper'
require 'testcentricity_web/exception_queue_helper'
require 'testcentricity_web/page_objects_helper'
require 'testcentricity_web/page_sections_helper'
require 'testcentricity_web/siebel_open_ui_helper'
require 'testcentricity_web/ui_elements_helper'
require 'testcentricity_web/utility_helpers'
require 'testcentricity_web/environment'
require 'capybara/cucumber'
require 'rspec/expectations'

module TestCentricity
  class PageManager
    attr_accessor :current_page

    @page_objects = {}

    def self.register_page_object(page_ref, page_object)
      @page_objects[page_ref] = page_object unless @page_objects.has_key?(page_ref)
      page_key = page_object.page_name.gsub(/\s+/, "").downcase.to_sym
      if page_key != page_ref
        @page_objects[page_key] = page_object unless @page_objects.has_key?(page_key)
      end
    end

    def self.loaded?
      not @page_objects.empty?
    end

    def self.pages
      @page_objects
    end

    def self.find_page(page_name)
      (page_name.is_a? String) ? page_id = page_name.gsub(/\s+/, "").downcase.to_sym : page_id = page_name
      @page_objects[page_id]
    end

    def self.current_page
      @current_page
    end

    def self.set_current_page(page)
      @current_page = page
    end
  end

  class DataManager
    @data_objects = {}

    def self.register_data_object(data_type, data_class)
      @data_objects[data_type] = data_class unless @data_objects.has_key?(data_type)
    end

    def self.loaded?
      not @data_objects.empty?
    end

    def self.data_objects
      @data_objects
    end
  end
end
