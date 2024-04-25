# frozen_string_literal: true

RSpec.describe TestCentricity::WebDriverConnect, mobile: true do
  include_context 'test_site'

  before(:context) do
    ENV['DEVICE_TYPE'] = 'tablet'
    ENV['CHROMEDRIVER_EXECUTABLE'] = '/Users/Shared/config/webdrivers/chromedriver'
    # start Appium server
    $server = TestCentricity::AppiumServer.new
    $server.start
  end

  context 'Connect to locally hosted mobile device simulator using W3C desired_capabilities hash' do
    it 'connects to iOS Simulator - desired_capabilities hash' do
      caps = {
        driver: :appium,
        device_type: :tablet,
        endpoint: 'http://localhost:4723',
        capabilities: {
          platformName: :ios,
          browserName: :safari,
          'appium:platformVersion': '17.2',
          'appium:deviceName': 'iPad Pro (12.9-inch) (6th generation)',
          'appium:automationName': 'XCUITest',
          'appium:orientation': 'LANDSCAPE'
        }
      }
      WebDriverConnect.initialize_web_driver(caps)
      verify_mobile_browser(browser = :safari, device_os = :ios)
      expect(Environ.device_name).to eq('iPad Pro (12.9-inch) (6th generation)')
      expect(Environ.device_os_version).to eq('17.2')
      expect(Environ.device_orientation).to eq(:landscape)
    end

    it 'connects to Android Simulator - desired_capabilities hash' do
      caps = {
        driver: :appium,
        device_type: :tablet,
        capabilities: {
          platformName: :android,
          browserName: :chrome,
          'appium:platformVersion': '12.0',
          'appium:deviceName': 'Pixel_C_API_31',
          'appium:avd': 'Pixel_C_API_31',
          'appium:automationName': 'UiAutomator2',
          'appium:orientation': 'PORTRAIT',
          'appium:chromedriverExecutable': ENV['CHROMEDRIVER_EXECUTABLE']
        }
      }
      WebDriverConnect.initialize_web_driver(caps)
      verify_mobile_browser(browser = :chrome, device_os = :android)
      expect(Environ.device_name).to eq('Pixel_C_API_31')
      expect(Environ.device_os_version).to eq('12.0')
      expect(Environ.device_orientation).to eq(:portrait)
    end

    it 'connects to iOS Simulator with a user-defined driver name' do
      caps = {
        driver: :appium,
        device_type: :tablet,
        driver_name: :my_custom_ios_driver,
        capabilities: {
          platformName: :ios,
          browserName: :safari,
          'appium:platformVersion': '17.2',
          'appium:deviceName': 'iPad Pro (12.9-inch) (6th generation)',
          'appium:automationName': 'XCUITest',
          'appium:orientation': 'LANDSCAPE'
        },
        endpoint: 'http://localhost:4723'
      }
      WebDriverConnect.initialize_web_driver(caps)
      verify_mobile_browser(browser = :safari, device_os = :ios, driver_name = :my_custom_ios_driver)
      expect(Environ.device_name).to eq('iPad Pro (12.9-inch) (6th generation)')
      expect(Environ.device_os_version).to eq('17.2')
      expect(Environ.device_orientation).to eq(:landscape)
    end

    it 'connects to Android Simulator with a user-defined driver name' do
      caps = {
        driver: :appium,
        device_type: :tablet,
        driver_name: :my_custom_android_driver,
        capabilities: {
          platformName: :android,
          browserName: :chrome,
          'appium:platformVersion': '12.0',
          'appium:deviceName': 'Pixel_C_API_31',
          'appium:avd': 'Pixel_C_API_31',
          'appium:automationName': 'UiAutomator2',
          'appium:orientation': 'PORTRAIT',
          'appium:chromedriverExecutable': ENV['CHROMEDRIVER_EXECUTABLE']
        }
      }
      WebDriverConnect.initialize_web_driver(caps)
      verify_mobile_browser(browser = :chrome, device_os = :android, driver_name = :my_custom_android_driver)
      expect(Environ.device_name).to eq('Pixel_C_API_31')
      expect(Environ.device_os_version).to eq('12.0')
      expect(Environ.device_orientation).to eq(:portrait)
    end
  end

  context 'Connect to locally hosted mobile device simulator using environment variables' do
    it 'connects to iOS Simulator - environment variables' do
      ENV['DRIVER'] = 'appium'
      ENV['AUTOMATION_ENGINE'] = 'XCUITest'
      ENV['APP_PLATFORM_NAME'] = 'ios'
      ENV['APP_BROWSER'] = 'Safari'
      ENV['APP_VERSION'] = '17.2'
      ENV['APP_DEVICE'] = 'iPad Pro (12.9-inch) (6th generation)'
      ENV['ORIENTATION'] = 'portrait'
      WebDriverConnect.initialize_web_driver
      verify_mobile_browser(browser = :safari, device_os = :ios)
      expect(Environ.device_name).to eq(ENV['APP_DEVICE'])
      expect(Environ.device_os_version).to eq(ENV['APP_VERSION'])
      expect(Environ.device_orientation).to eq(:portrait)
    end

    it 'connects to Android Simulator - environment variables' do
      ENV['DRIVER'] = 'appium'
      ENV['AUTOMATION_ENGINE'] = 'UiAutomator2'
      ENV['APP_PLATFORM_NAME'] = 'Android'
      ENV['APP_BROWSER'] = 'Chrome'
      ENV['APP_VERSION'] = '12.0'
      ENV['APP_DEVICE'] = 'Pixel_C_API_31'
      ENV['ORIENTATION'] = 'landscape'
      WebDriverConnect.initialize_web_driver
      verify_mobile_browser(browser = :chrome, device_os = :android)
      expect(Environ.device_name).to eq(ENV['APP_DEVICE'])
      expect(Environ.device_os_version).to eq(ENV['APP_VERSION'])
      expect(Environ.device_orientation).to eq(:landscape)
    end
  end

  def verify_mobile_browser(browser, device_os, driver_name = nil)
    # load Apple web site
    Capybara.page.driver.browser.navigate.to(test_site_url)
    Capybara.page.find(:css, test_site_locator, wait: 10, visible: true)
    # verify Environs are correctly set
    expect(Environ.browser).to eq(browser)
    expect(Environ.device_os).to eq(device_os)
    expect(Environ.platform).to eq(:mobile)
    expect(Environ.headless).to eq(false)
    expect(Environ.session_state).to eq(:running)
    expect(Environ.driver).to eq(:appium)
    expect(Environ.device).to eq(:simulator)
    expect(Environ.device_type).to eq(:tablet)
    expect(Environ.is_web?).to eq(false)
    if device_os == :ios
      expect(Environ.is_ios?).to eq(true)
    else
      expect(Environ.is_android?).to eq(true)
    end
    driver_name = "appium_#{Environ.browser}".downcase.to_sym if driver_name.nil?
    expect(Capybara.current_driver).to eq(driver_name)
  end

  after(:each) do
    WebDriverConnect.close_all_drivers
  end

  after(:context) do
    $server.stop if Environ.driver == :appium && $server.running?
  end
end
