# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'testcentricity_web/version'

Gem::Specification.new do |spec|
  spec.name          = 'testcentricity_web'
  spec.version       = TestCentricityWeb::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 2.1.1'
  spec.authors       = ['A.J. Mrozinski']
  spec.email         = ['testcentricity@gmail.com']
  spec.summary       = %q{A Page Object and Data Object Model Framework for desktop and mobile web testing}
  spec.description   = %q{
    TestCentricity™ Web core generic framework for desktop and mobile web site testing implements a Page Object Model DSL
    for use with Cucumber, Capybara, and Selenium-Webdriver. The TestCentricity™ Web gem supports running testing against
    locally hosted desktop browsers (Firefox, Chrome, Safari, IE, or Edge), locally hosted emulated mobile (iOS, Android,
    Windows Phone, Blackberry) browsers using Firefox or Chrome, a "headless" browser (using Poltergeist and PhantomJS),
    mobile Safari browsers on iOS device simulators (using Appium and XCode on OS X), or cloud hosted desktop or mobile
    web browsers (using the BrowserStack, Sauce Labs, CrossBrowserTesting, or TestingBot services).}
  spec.homepage      = ''
  spec.license       = 'BSD3'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'

  spec.add_dependency 'capybara', ['>= 2.1', '< 3.0']
  spec.add_dependency 'test-unit'
  spec.add_dependency 'selenium-webdriver', '>= 2.50.0'
  spec.add_dependency 'poltergeist'
  spec.add_dependency 'faker', '>= 1.6.1'
  spec.add_dependency 'chronic', '>= 0.10.2'
  spec.add_dependency 'spreadsheet', '>= 1.1.1'
end
