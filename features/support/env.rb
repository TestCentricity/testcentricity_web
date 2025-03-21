# frozen_string_literal: true

require 'capybara/cucumber'
require 'parallel_tests'
require 'require_all'
require 'simplecov'
require 'testcentricity_web'

include TestCentricity

coverage_report_name = "Features-#{ENV['WEB_BROWSER']}-#{ENV['DRIVER']}" + (ENV['TEST_ENV_NUMBER'] || '')
SimpleCov.command_name("#{coverage_report_name}-#{Time.now.strftime('%Y%m%d%H%M%S%L')}")
SimpleCov.merge_timeout 9600

require_relative 'world_data'
require_relative 'world_pages'

require_rel 'data'
require_rel 'sections'
require_rel 'pages'
require_rel 'cloud_credentials'

$LOAD_PATH << './lib'

# set Capybara's default max wait time to 20 seconds
Capybara.default_max_wait_time = 20

# set the default locale and auto load all translations from config/locales/*.rb,yml.
ENV['LOCALE'] = 'en-US' unless ENV['LOCALE']
I18n.load_path += Dir['config/locales/*.{rb,yml}']
I18n.default_locale = ENV['LOCALE']
I18n.locale = ENV['LOCALE']
Faker::Config.locale = ENV['LOCALE']

# load cloud services credentials into environment variables
load_cloud_credentials
# instantiate all data objects and target test environment
include WorldData
ENV['DATA_SOURCE'] = 'yaml' unless ENV['DATA_SOURCE']
environs.find_environ(ENV['TEST_ENVIRONMENT'], ENV['DATA_SOURCE'].downcase.to_sym)
WorldData.instantiate_data_objects

# instantiate all page objects
include WorldPages
WorldPages.instantiate_page_objects

# establish connection to target web browser

# suppress Capybara warnings for :clear_local_storage and :clear_session_storage
Selenium::WebDriver.logger.ignore(:clear_local_storage, :clear_session_storage)

site_url = if Environ.test_environment == :local
        "file://#{File.dirname(__FILE__)}/../../test_site"
      else
        Environ.current.app_host
      end
caps = if ENV['W3C_CAPS']
         capabilities.find_capabilities(ENV['W3C_CAPS'])
         { app_host: site_url }.merge(Capabilities.current.caps)
       else
         { app_host: site_url }
       end
WebDriverConnect.initialize_web_driver(caps)
