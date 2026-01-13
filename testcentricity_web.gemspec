# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'testcentricity_web/version'

Gem::Specification.new do |spec|
  spec.name = 'testcentricity_web'
  spec.version = TestCentricityWeb::VERSION
  spec.platform = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 3.1.0'
  spec.authors = ['A.J. Mrozinski']
  spec.email = ['support@testcentricity.com']
  spec.summary = 'A Page Object Model Framework for desktop and mobile web testing'
  spec.description = '
    The TestCentricity™ For Web core framework for desktop and mobile web browser-based app testing implements a Page Object
    Model DSL for use with Cucumber or RSpec, and Selenium-Webdriver. The gem also facilitates the configuration of the
    appropriate Selenium-Webdriver capabilities required to establish connections to locally hosted desktop browsers,
    locally hosted emulated mobile browsers (iOS, Android, etc.) running within a local instance of Chrome, mobile Safari
    browsers on iOS device simulators or physical iOS devices, mobile Chrome browsers on Android Studio virtual device
    emulators, or cloud hosted desktop or mobile web browsers (using BrowserStack, Sauce Labs, TestingBot, or LambdaTest
    services).'
  spec.homepage = 'https://github.com/TestCentricity/testcentricity_web'
  spec.license = 'BSD-3-Clause'
  spec.metadata = {
    'changelog_uri' => 'https://github.com/TestCentricity/testcentricity_web/blob/main/CHANGELOG.md',
    'bug_tracker_uri' => 'https://github.com/TestCentricity/testcentricity_web/issues',
    'wiki_uri' => 'https://github.com/TestCentricity/testcentricity_web/wiki',
    'documentation_uri' => 'https://www.rubydoc.info/gems/testcentricity_web'
  }

  spec.files = Dir.glob('lib/**/*') + %w[README.md CHANGELOG.md LICENSE.md .yardopts]
  spec.require_paths = ['lib']
  spec.requirements << 'Capybara, Selenium-WebDriver'

  spec.add_development_dependency 'axe-core-cucumber'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'cucumber', '10.2.0'
  spec.add_development_dependency 'cuke_modeler', '~> 3.0'
  spec.add_development_dependency 'docker-compose'
  spec.add_development_dependency 'httparty'
  spec.add_development_dependency 'parallel_tests'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'require_all', '=1.5.0'
  spec.add_development_dependency 'rspec', '>= 3.13.0'
  spec.add_development_dependency 'selenium-webdriver', '~>4.39.0'
  spec.add_development_dependency 'simplecov', ['~> 0.18']
  spec.add_development_dependency 'yard', ['>= 0.9.0']

  spec.add_runtime_dependency 'activesupport', '>= 4.0'
  spec.add_runtime_dependency 'appium_lib', '~> 16.1.1'
  spec.add_runtime_dependency 'browserstack-local'
  spec.add_runtime_dependency 'capybara', '3.40.0'
  spec.add_runtime_dependency 'childprocess'
  spec.add_runtime_dependency 'chronic', '0.10.2'
  spec.add_runtime_dependency 'faker'
  spec.add_runtime_dependency 'i18n'
  spec.add_runtime_dependency 'os', '~> 1.0'
  spec.add_runtime_dependency 'smarter_csv'
  spec.add_runtime_dependency 'test-unit'
  spec.add_runtime_dependency 'virtus'
end
