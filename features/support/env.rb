require 'capybara/cucumber'
require 'parallel_tests'
require 'appium_capybara'
require 'require_all'
require 'simplecov'
require 'testcentricity_web'

SimpleCov.command_name "features #{ENV['WEB_BROWSER']}" + (ENV['TEST_ENV_NUMBER'] || '')

# require_relative 'world_data'
require_relative 'world_pages'

# require_rel 'data'
# require_rel 'sections'
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
# include WorldData
# environs.find_environ(ENV['TEST_ENVIRONMENT'], :yaml)
# WorldData.instantiate_data_objects

# instantiate all page objects
include WorldPages
WorldPages.instantiate_page_objects

# establish connection to WebDriver and target web browser
Webdrivers.cache_time = 86_400

options = { app_host: "file://#{File.dirname(__FILE__)}/../../test_site" }
options = { app_host: "http://192.168.1.129"}
TestCentricity::WebDriverConnect.initialize_web_driver(options)