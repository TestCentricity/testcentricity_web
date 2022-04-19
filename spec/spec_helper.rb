# frozen_string_literal: true

require 'capybara/rspec'
require 'httparty'
require 'require_all'
require 'simplecov'
require 'testcentricity_web'

require_rel 'fixtures'

include TestCentricity

SimpleCov.command_name("RSpec-#{Time.now.strftime('%Y%m%d%H%M%S')}")

$LOAD_PATH << './lib'

# set the default locale and auto load all translations from config/locales/*.rb,yml.
ENV['LOCALE'] = 'en-US' unless ENV['LOCALE']
I18n.load_path += Dir['config/locales/*.{rb,yml}']
I18n.default_locale = 'en-US'
I18n.locale = ENV['LOCALE']
Faker::Config.locale = ENV['LOCALE']

# prevent Test::Unit's AutoRunner from executing during RSpec's rake task
Test::Unit.run = true if defined?(Test::Unit) && Test::Unit.respond_to?(:run=)

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.allow_message_expectations_on_nil = true
    mocks.verify_doubled_constant_names = true
    mocks.verify_partial_doubles = true
  end
end
