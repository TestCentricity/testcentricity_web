# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'testcentricity_web/version'

Gem::Specification.new do |spec|
  spec.name          = 'testcentricity_web'
  spec.version       = TestCentricityWeb::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 2.7.5'
  spec.authors       = ['A.J. Mrozinski']
  spec.email         = ['testcentricity@gmail.com']
  spec.summary       = 'A Page Object Model Framework for desktop and mobile web testing'
  spec.description   = '
    The TestCentricity™ Web core framework for desktop and mobile web browser-based app testing implements a Page Object
    Model DSL for use with Cucumber, Capybara, and Selenium-Webdriver v4.x. The gem also facilitates the configuration of
    the appropriate Selenium-Webdriver capabilities required to establish a connection with locally hosted desktop browsers,
    locally hosted emulated mobile browsers (iOS, Android, etc.) running within a local instance of Chrome, mobile Safari
    browsers on iOS device simulators or physical iOS devices, mobile Chrome or Android browsers on Android Studio virtual
    device emulators, or cloud hosted desktop or mobile web browsers (using BrowserStack, Sauce Labs, TestingBot, or
    LambdaTest services).'
  spec.homepage      = 'https://github.com/TestCentricity/testcentricity_web'
  spec.license       = 'BSD-3-Clause'
  spec.metadata = {
    'changelog_uri' => 'https://github.com/TestCentricity/testcentricity_web/blob/main/CHANGELOG.md',
    'documentation_uri' => 'https://www.rubydoc.info/gems/testcentricity_web'
  }

  spec.files         = Dir.glob('lib/**/*') + %w[README.md CHANGELOG.md LICENSE.txt .yardopts]
  spec.require_paths = ['lib']
  spec.requirements  << 'Capybara, Selenium-WebDriver'

  spec.add_development_dependency 'appium_capybara'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'cucumber'
  spec.add_development_dependency 'cuke_modeler', '~> 3.0'
  spec.add_development_dependency 'docker-compose'
  spec.add_development_dependency 'httparty'
  spec.add_development_dependency 'parallel_tests'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'require_all', '=1.5.0'
  spec.add_development_dependency 'rspec', '~> 3.10'
  spec.add_development_dependency 'simplecov', ['~> 0.18']
  spec.add_development_dependency 'yard', ['>= 0.9.0']

  spec.add_runtime_dependency 'appium_lib'
  spec.add_runtime_dependency 'browserstack-local'
  spec.add_runtime_dependency 'capybara', '>= 3.1', '< 4'
  spec.add_runtime_dependency 'childprocess'
  spec.add_runtime_dependency 'chronic', '0.10.2'
  spec.add_runtime_dependency 'faker'
  spec.add_runtime_dependency 'i18n'
  spec.add_runtime_dependency 'os', '~> 1.0'
  spec.add_runtime_dependency 'selenium-webdriver', '>= 4.0', '< 5'
  spec.add_runtime_dependency 'spreadsheet', '1.1.7'
  spec.add_runtime_dependency 'test-unit'
  spec.add_runtime_dependency 'virtus'
  spec.add_runtime_dependency 'webdrivers', '~> 5.0'
end
