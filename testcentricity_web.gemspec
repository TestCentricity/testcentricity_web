# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'testcentricity_web/version'

Gem::Specification.new do |spec|
  spec.name          = 'testcentricity_web'
  spec.version       = TestCentricityWeb::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 2.3.0'
  spec.authors       = ['A.J. Mrozinski']
  spec.email         = ['testcentricity@gmail.com']
  spec.summary       = %q{A Page Object and Data Object Model Framework for desktop and mobile web testing}
  spec.description   = %q{
    The TestCentricity™ Web core generic framework for desktop and mobile web browser-based applications testing implements
    a Page Object Model DSL for use with Cucumber, Capybara, and Selenium-Webdriver. The gem provides support for running
    automated tests against locally hosted desktop browsers, locally hosted emulated mobile browsers (iOS, Android, Windows
    Phone, Blackberry, Kindle Fire) running within a local instance of Chrome, mobile Safari browsers on iOS device simulators
     or physical iOS devices (using Appium and XCode on OS X), mobile Chrome or Android browsers on Android Studio virtual
    device emulators (using Appium and Android Studio on OS X), or cloud hosted desktop or mobile web browsers (using the
    BrowserStack, Sauce Labs, CrossBrowserTesting, TestingBot, or Gridlastic services).}
  spec.homepage      = ''
  spec.license       = 'BSD-3-Clause'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.requirements  << 'Capybara, Selenium-WebDriver'

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'

  spec.add_runtime_dependency 'appium_lib'
  spec.add_runtime_dependency 'browserstack-local'
  spec.add_runtime_dependency 'capybara', '>= 3.1', '< 4'
  spec.add_runtime_dependency 'childprocess', '~> 0.5'
  spec.add_runtime_dependency 'chronic', '0.10.2'
  spec.add_runtime_dependency 'faker'
  spec.add_runtime_dependency 'i18n'
  spec.add_runtime_dependency 'os', '~> 1.0'
  spec.add_runtime_dependency 'selenium-webdriver', ['>= 3.11.0', '< 4.0']
  spec.add_runtime_dependency 'spreadsheet', '1.1.7'
  spec.add_runtime_dependency 'test-unit'
  spec.add_runtime_dependency 'webdrivers', '~> 3.3'
  spec.add_runtime_dependency 'virtus'
end
