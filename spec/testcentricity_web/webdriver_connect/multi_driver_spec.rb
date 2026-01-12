# frozen_string_literal: true

RSpec.describe TestCentricity::WebDriverConnect, multi_driver_spec: true do
  include_context 'test_site'

  before(:context) do
    ENV['BROWSER_TILE'] = 'true'
    # start Appium server
    $server = TestCentricity::AppiumServer.new
    $server.start
  end

  context 'Connect to multiple locally hosted desktop and mobile web browsers' do
    it 'raises exception when named driver cannot be found' do
      # instantiate a locally hosted desktop Chrome browser
      caps = {
        capabilities: { browserName: :chrome },
        driver_name: :my_chrome,
        driver: :webdriver,
        browser_size: [1100, 900]
      }
      WebDriverConnect.initialize_web_driver(caps)
      expect { WebDriverConnect.activate_driver(:emulated_iphone) }.to raise_error("Could not find a driver named 'emulated_iphone'")
    end

    it 'connects to multiple mobile browsers hosted on device simulators' do
      # instantiate a locally hosted mobile Safari browser in an iOS iPhone simulator
      caps = {
        driver: :appium,
        driver_name: :my_iphone,
        device_type: :phone,
        capabilities: {
          platformName: :ios,
          browserName: :safari,
          'appium:platformVersion': '17.2',
          'appium:deviceName': 'iPhone 13 Pro Max',
          'appium:automationName': 'XCUITest',
          'appium:newCommandTimeout': 30,
          'appium:wdaLocalPort': 8100
        }
      }
      WebDriverConnect.initialize_web_driver(caps)

      # instantiate a locally hosted mobile Chrome browser in an Android tablet simulator
      caps = {
        driver: :appium,
        driver_name: :my_android_tablet,
        device_type: :tablet,
        capabilities: {
          platformName: :android,
          browserName: :chrome,
          'appium:platformVersion': '12.0',
          'appium:deviceName': 'Pixel_C_API_31',
          'appium:avd': 'Pixel_C_API_31',
          'appium:automationName': 'UiAutomator2',
          'appium:orientation': 'PORTRAIT',
          'appium:chromedriverExecutable': '/Users/Shared/config/webdrivers/chromedriver'
        }
      }
      WebDriverConnect.initialize_web_driver(caps)

      # instantiate a locally hosted mobile Safari browser in an iOS iPad simulator
      caps = {
        driver: :appium,
        driver_name: :my_ipad,
        device_type: :tablet,
        endpoint: 'http://localhost:4723/wd/hub',
        capabilities: {
          platformName: :ios,
          browserName: :safari,
          'appium:platformVersion': '17.2',
          'appium:deviceName': 'iPad Pro (12.9-inch) (6th generation)',
          'appium:automationName': 'XCUITest',
          'appium:orientation': 'PORTRAIT',
          'appium:newCommandTimeout': 30,
          'appium:wdaLocalPort': 8101
        }
      }
      WebDriverConnect.initialize_web_driver(caps)

      # instantiate a locally hosted mobile Chrome browser in an Android phone simulator
      caps = {
        driver: :appium,
        driver_name: :my_android_phone,
        device_type: :phone,
        capabilities: {
          platformName: :android,
          browserName: :chrome,
          'appium:platformVersion': '12.0',
          'appium:deviceName': 'Pixel_5_API_31',
          'appium:avd': 'Pixel_5_API_31',
          'appium:automationName': 'UiAutomator2',
          'appium:chromedriverExecutable': '/Users/Shared/config/webdrivers/chromedriver'
        }
      }
      WebDriverConnect.initialize_web_driver(caps)

      # verify that 4 driver instances have been initialized
      expect(WebDriverConnect.num_drivers).to eq(4)

      # activate and verify the local mobile Safari browser instance
      WebDriverConnect.activate_driver(:my_iphone)
      verify_mobile_browser(browser = :safari, device_os = :ios, device_type = :phone, driver_name = :my_iphone)
      expect(Environ.device_name).to eq('iPhone 13 Pro Max')
      expect(Environ.device_os_version).to eq('17.2')

      # activate and verify the local mobile Chrome browser/phone instance
      WebDriverConnect.activate_driver(:my_android_phone)
      verify_mobile_browser(browser = :chrome, device_os = :android, device_type = :phone, driver_name = :my_android_phone)
      expect(Environ.device_name).to eq('Pixel_5_API_31')
      expect(Environ.device_os_version).to eq('12.0')

      # activate and verify the local mobile Safari browser/iPad instance
      WebDriverConnect.activate_driver(:my_ipad)
      verify_mobile_browser(browser = :safari, device_os = :ios, device_type = :tablet, driver_name = :my_ipad)
      expect(Environ.device_name).to eq('iPad Pro (12.9-inch) (6th generation)')
      expect(Environ.device_os_version).to eq('17.2')
      expect(Environ.device_orientation).to eq(:portrait)

      # activate and verify the local mobile Chrome browser/tablet instance
      WebDriverConnect.activate_driver(:my_android_tablet)
      verify_mobile_browser(browser = :chrome, device_os = :android, device_type = :tablet, driver_name = :my_android_tablet)
      expect(Environ.device_name).to eq('Pixel_C_API_31')
      expect(Environ.device_os_version).to eq('12.0')
      expect(Environ.device_orientation).to eq(:portrait)
    end

    it 'connects to multiple desktop and emulated mobile browsers' do
      # instantiate a locally hosted emulated iPad browser
      caps = {
        capabilities: { browserName: :ipad_pro_12_9 },
        driver_name: :emulated_ipad,
        driver: :webdriver
      }
      WebDriverConnect.initialize_web_driver(caps)

      # instantiate a locally hosted desktop Edge browser
      caps = {
        capabilities: { browserName: :edge },
        driver: :webdriver,
        browser_size: [1000, 800]
      }
      WebDriverConnect.initialize_web_driver(caps)

      # instantiate a locally hosted desktop Firefox browser
      caps = {
        capabilities: { browserName: :firefox },
        driver: :webdriver,
        browser_size: [1100, 900]
      }
      WebDriverConnect.initialize_web_driver(caps)

      # instantiate a locally hosted desktop Safari browser
      caps = {
        capabilities: { browserName: :safari },
        driver: :webdriver,
        browser_size: [800, 700]
      }
      WebDriverConnect.initialize_web_driver(caps)

      # instantiate a locally hosted emulated iPhone browser
      caps = {
        capabilities: { browserName: :iphone_11_pro_max },
        driver_name: :emulated_iphone,
        driver: :webdriver
      }
      WebDriverConnect.initialize_web_driver(caps)

      # verify that 5 driver instances have been initialized
      expect(WebDriverConnect.num_drivers).to eq(5)

      # activate and verify the local Firefox desktop browser instance
      WebDriverConnect.activate_driver(:local_firefox)
      verify_local_browser(browser = :firefox, platform = :desktop, headless = false)

      # activate and verify the local emulated iPhone browser instance
      WebDriverConnect.activate_driver(:emulated_iphone)
      verify_local_browser(browser = :iphone_11_pro_max, platform = :mobile, headless = false, driver_name = :emulated_iphone)
      expect(Environ.device_orientation).to eq(:portrait)
      expect(Environ.browser_size).to eq([414, 896])

      # activate and verify the local Safari desktop browser instance
      WebDriverConnect.activate_driver(:local_safari)
      verify_local_browser(browser = :safari, platform = :desktop, headless = false)

      # activate and verify the local emulated iPad browser instance
      WebDriverConnect.activate_driver(:emulated_ipad)
      verify_local_browser(browser = :ipad_pro_12_9, platform = :mobile, headless = false, driver_name = :emulated_ipad)
      expect(Environ.device_orientation).to eq(:landscape)
      expect(Environ.browser_size).to eq([1366, 1024])

      # activate and verify the local Edge desktop browser instance
      WebDriverConnect.activate_driver(:local_edge)
      verify_local_browser(browser = :edge, platform = :desktop, headless = false)
    end
  end

  def verify_local_browser(browser, platform, headless, driver_name = nil)
    driver_name = "local_#{Environ.browser}".downcase.to_sym if driver_name.nil?
    expect(Environ.driver_name).to eq(driver_name)
    expect(Capybara.current_driver).to eq(driver_name)
    # load Apple web site
    Capybara.page.driver.browser.navigate.to(test_site_url)
    Capybara.page.find(:css, test_site_locator, wait: 10, visible: true)
    # verify Environs are correctly set
    expect(Environ.browser).to eq(browser)
    expect(Environ.platform).to eq(platform)
    expect(Environ.headless).to eq(headless)
    expect(Environ.session_state).to eq(:running)
    expect(Environ.driver).to eq(:webdriver)
    expect(Environ.device).to eq(:web)
    expect(Environ.is_web?).to eq(true)
    expect(Environ.grid).to eq(nil)
  end

  def verify_mobile_browser(browser, device_os, device_type, driver_name = nil)
    driver_name = "appium_#{Environ.browser}".downcase.to_sym if driver_name.nil?
    expect(Environ.driver_name).to eq(driver_name)
    expect(Capybara.current_driver).to eq(driver_name)
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
    expect(Environ.device_type).to eq(device_type)
    expect(Environ.is_web?).to eq(false)
    if device_os == :ios
      expect(Environ.is_ios?).to eq(true)
    else
      expect(Environ.is_android?).to eq(true)
    end
  end

  after(:each) do
    WebDriverConnect.close_all_drivers
    # verify that all driver instances have been closed
    expect(WebDriverConnect.num_drivers).to eq(0)
  end

  after(:context) do
    $server.stop if Environ.driver == :appium && $server.running?
  end
end
