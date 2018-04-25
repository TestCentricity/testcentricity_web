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
    The TestCentricity™ Web core generic framework for desktop and mobile web site testing implements a Page Object Model DSL
    for use with Cucumber, Capybara, and Selenium-Webdriver. The TestCentricity™ Web gem supports running automated tests
    against locally hosted desktop browsers (Firefox, Chrome, Safari, or IE), locally hosted emulated mobile browsers (iOS,
    Android, Windows Phone, Blackberry, Kindle Fire) running within a locally hosted instance of Chrome, mobile Safari browsers on
    iOS device simulators or physical iOS devices  (using Appium and XCode on OS X), mobile Chrome or Android browsers on Android
    Studio virtual device emulators (using Appium and Android Studio on OS X), or cloud hosted desktop or mobile web browsers
    (using the BrowserStack, Sauce Labs, CrossBrowserTesting, or TestingBot services).}
  spec.homepage      = ''
  spec.license       = 'BSD3'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.requirements  << 'Capybara, Selenium-WebDriver'

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'

  spec.add_dependency 'capybara'
  spec.add_dependency 'test-unit'
  spec.add_dependency 'selenium-webdriver', '>= 3.11.0'
  spec.add_dependency 'faker'
  spec.add_dependency 'chronic', '0.10.2'
  spec.add_dependency 'spreadsheet', '1.1.1'
  spec.add_dependency 'os'
  spec.add_dependency 'i18n'
  spec.add_dependency 'browserstack-local'

  spec.add_runtime_dependency 'childprocess', '~> 0.5'
end
