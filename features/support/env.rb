require 'capybara/cucumber'
require 'parallel_tests'
require 'appium_capybara'
require 'require_all'
require 'simplecov'
require 'testcentricity_web'

include TestCentricity

SimpleCov.command_name("features-#{ENV['WEB_BROWSER']}-#{ENV['SELENIUM']}" + (ENV['TEST_ENV_NUMBER'] || ''))

require_relative 'world_data'
require_relative 'world_pages'

require_rel 'data'
require_rel 'sections'
require_rel 'pages'

$LOAD_PATH << './lib'

# set Capybara's default max wait time to 20 seconds
Capybara.default_max_wait_time = 20

# set the default locale and auto load all translations from config/locales/*.rb,yml.
ENV['LOCALE'] = 'en-US' unless ENV['LOCALE']
I18n.load_path += Dir['config/locales/*.{rb,yml}']
I18n.default_locale = ENV['LOCALE']
I18n.locale = ENV['LOCALE']
Faker::Config.locale = ENV['LOCALE']

# instantiate all data objects and target test environment
include WorldData
ENV['DATA_SOURCE'] = 'yaml' unless ENV['DATA_SOURCE']
environs.find_environ(ENV['TEST_ENVIRONMENT'], ENV['DATA_SOURCE'].downcase.to_sym)
WorldData.instantiate_data_objects

# instantiate all page objects
include WorldPages
WorldPages.instantiate_page_objects

# establish connection to WebDriver and target web browser
Webdrivers.cache_time = 86_400


url = if ENV['TEST_ENVIRONMENT'].downcase == 'local'
        "file://#{File.dirname(__FILE__)}/../../test_site"
      else
        Environ.current.app_host
      end
WebDriverConnect.initialize_web_driver(app_host: url)
