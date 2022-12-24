# frozen_string_literal: true

RSpec.describe TestCentricity::WebDriverConnect, multi_driver_spec: true do
  before(:context) do
    ENV['SELENIUM'] = ''
    # start Appium server
    $server = TestCentricity::AppiumServer.new
    $server.start
  end

  context 'Connect to multiple locally hosted desktop and mobile web browsers' do
    it 'connects to multiple emulated mobile browsers' do
      # instantiate a locally hosted emulated iPhone browser
      caps = {
        desired_capabilities: { browserName: :iphone_11_pro_max },
        driver_name: :emulated_iphone,
        driver: :webdriver
      }
      WebDriverConnect.initialize_web_driver(caps)

      # instantiate a locally hosted emulated iPad browser
      caps = {
        desired_capabilities: { browserName: :ipad_pro_12_9 },
        driver_name: :emulated_ipad,
        driver: :webdriver
      }
      WebDriverConnect.initialize_driver(caps)

      # activate and verify the local emulated iPhone browser instance
      WebDriverConnect.active_driver(:emulated_iphone)
      verify_local_browser(browser = :iphone_11_pro_max, platform = :mobile, headless = false, driver_name = :emulated_iphone)
      expect(Environ.device_orientation).to eq(:portrait)
      expect(Environ.browser_size).to eq([414, 869])

      # activate and verify the local emulated iPad browser instance
      WebDriverConnect.active_driver(:emulated_ipad)
      verify_local_browser(browser = :ipad_pro_12_9, platform = :mobile, headless = false, driver_name = :emulated_ipad)
      expect(Environ.device_orientation).to eq(:landscape)
      expect(Environ.browser_size).to eq([1366, 1024])
    end

    it 'connects to multiple desktop and mobile browsers' do
      # instantiate a locally hosted desktop Chrome browser
      caps = {
        desired_capabilities: {
          browserName: :chrome,
          browser_size: [1100, 900]
        },
        driver_name: :my_chrome,
        driver: :webdriver
      }
      WebDriverConnect.initialize_web_driver(caps)

      # instantiate a locally hosted mobile Safari browser in an iOS simulator
      caps = {
        driver: :appium,
        device_type: :tablet,
        endpoint: 'http://localhost:4723/wd/hub',
        desired_capabilities: {
          platformName: 'ios',
          browserName: 'Safari',
          'appium:platformVersion': '15.4',
          'appium:deviceName': 'iPad Pro (12.9-inch) (5th generation)',
          'appium:automationName': 'XCUITest',
          'appium:orientation': 'LANDSCAPE'
        }
      }
      WebDriverConnect.initialize_driver(caps)

      # instantiate a locally hosted desktop Edge browser
      caps = {
        desired_capabilities: {
          browserName: :edge,
          browser_size: [1000, 800]
        },
        driver_name: :my_edge,
        driver: :webdriver
      }
      WebDriverConnect.initialize_driver(caps)

      # instantiate a locally hosted desktop Firefox browser
      caps = {
        desired_capabilities: { browserName: :firefox },
        driver: :webdriver
      }
      WebDriverConnect.initialize_driver(caps)

      # activate and verify the local Edge desktop browser instance
      WebDriverConnect.active_driver(:my_edge)
      verify_local_browser(browser = :edge, platform = :desktop, headless = false, driver_name = :my_edge)

      # activate and verify the local mobile Safari browser instance
      WebDriverConnect.active_driver(:appium_safari)
      verify_mobile_browser(browser = :safari, device_os = :ios, device_type = :tablet)
      expect(Environ.device_name).to eq('iPad Pro (12.9-inch) (5th generation)')
      expect(Environ.device_os_version).to eq('15.4')
      expect(Environ.device_orientation).to eq(:landscape)

      # activate and verify the local Chrome desktop browser instance
      WebDriverConnect.active_driver(:my_chrome)
      verify_local_browser(browser = :chrome, platform = :desktop, headless = false, driver_name = :my_chrome)

      # activate and verify the local Firefox desktop browser instance
      WebDriverConnect.active_driver(:local_firefox)
      verify_local_browser(browser = :firefox, platform = :desktop, headless = false)
    end

    it 'connects to multiple mobile browsers hosted on device simulators' do
      # instantiate a locally hosted mobile Safari browser in an iOS iPhone simulator
      caps = {
        driver: :appium,
        driver_name: :my_iphone,
        device_type: :phone,
        desired_capabilities: {
          platformName: 'ios',
          browserName: 'Safari',
          'appium:platformVersion': '15.4',
          'appium:deviceName': 'iPhone 13 Pro Max',
          'appium:automationName': 'XCUITest'
        }
      }
      WebDriverConnect.initialize_web_driver(caps)

      # instantiate a locally hosted mobile Chrome browser in an Android tablet simulator
      caps = {
        driver: :appium,
        driver_name: :my_android_tablet,
        device_type: :tablet,
        desired_capabilities: {
          platformName: 'Android',
          browserName: 'Chrome',
          'appium:platformVersion': '12.0',
          'appium:deviceName': 'Pixel_C_API_31',
          'appium:avd': 'Pixel_C_API_31',
          'appium:automationName': 'UiAutomator2',
          'appium:orientation': 'PORTRAIT',
          'appium:chromedriverExecutable': '/Users/Shared/config/webdrivers/chromedriver'
        }
      }
      WebDriverConnect.initialize_driver(caps)

      # instantiate a locally hosted mobile Safari browser in an iOS iPad simulator
      caps = {
        driver: :appium,
        driver_name: :my_ipad,
        device_type: :tablet,
        endpoint: 'http://localhost:4723/wd/hub',
        desired_capabilities: {
          platformName: 'ios',
          browserName: 'Safari',
          'appium:platformVersion': '15.4',
          'appium:deviceName': 'iPad Pro (12.9-inch) (5th generation)',
          'appium:automationName': 'XCUITest',
          'appium:orientation': 'PORTRAIT'
        }
      }
      WebDriverConnect.initialize_driver(caps)

      # instantiate a locally hosted mobile Chrome browser in an Android phone simulator
      caps = {
        driver: :appium,
        driver_name: :my_android_phone,
        device_type: :phone,
        desired_capabilities: {
          platformName: 'Android',
          browserName: 'Chrome',
          'appium:platformVersion': '12.0',
          'appium:deviceName': 'Pixel_5_API_31',
          'appium:avd': 'Pixel_5_API_31',
          'appium:automationName': 'UiAutomator2',
          'appium:chromedriverExecutable': '/Users/Shared/config/webdrivers/chromedriver'
        }
      }
      WebDriverConnect.initialize_driver(caps)

      # activate and verify the local mobile Safari browser/iPad instance
      WebDriverConnect.active_driver(:my_ipad)
      verify_mobile_browser(browser = :safari, device_os = :ios, device_type = :tablet, driver_name = :my_ipad)
      expect(Environ.device_name).to eq('iPad Pro (12.9-inch) (5th generation)')
      expect(Environ.device_os_version).to eq('15.4')
      expect(Environ.device_orientation).to eq(:portrait)

      # activate and verify the local mobile Chrome browser/tablet instance
      WebDriverConnect.active_driver(:my_android_tablet)
      verify_mobile_browser(browser = :chrome, device_os = :android, device_type = :tablet, driver_name = :my_android_tablet)
      expect(Environ.device_name).to eq('Pixel_C_API_31')
      expect(Environ.device_os_version).to eq('12.0')
      expect(Environ.device_orientation).to eq(:portrait)

      # activate and verify the local mobile Safari browser instance
      WebDriverConnect.active_driver(:my_iphone)
      verify_mobile_browser(browser = :safari, device_os = :ios, device_type = :phone, driver_name = :my_iphone)
      expect(Environ.device_name).to eq('iPhone 13 Pro Max')
      expect(Environ.device_os_version).to eq('15.4')

      # activate and verify the local mobile Chrome browser/phone instance
      WebDriverConnect.active_driver(:my_android_phone)
      verify_mobile_browser(browser = :chrome, device_os = :android, device_type = :phone, driver_name = :my_android_phone)
      expect(Environ.device_name).to eq('Pixel_5_API_31')
      expect(Environ.device_os_version).to eq('12.0')
    end
  end

  def verify_local_browser(browser, platform, headless, driver_name = nil)
    # load Apple web site
    Capybara.page.driver.browser.navigate.to('https://www.apple.com')
    Capybara.page.find(:css, 'nav#ac-globalnav', wait: 10, visible: true)
    # verify Environs are correctly set
    expect(Environ.browser).to eq(browser)
    expect(Environ.platform).to eq(platform)
    expect(Environ.headless).to eq(headless)
    expect(Environ.session_state).to eq(:running)
    expect(Environ.driver).to eq(:webdriver)
    expect(Environ.device).to eq(:web)
    expect(Environ.is_web?).to eq(true)
    expect(Environ.grid).to eq(nil)
    driver_name = "local_#{Environ.browser}".downcase.to_sym if driver_name.nil?
    expect(Capybara.current_driver).to eq(driver_name)
  end

  def verify_mobile_browser(browser, device_os, device_type, driver_name = nil)
    # load Apple web site
    Capybara.page.driver.browser.navigate.to('https://www.apple.com')
    Capybara.page.find(:css, 'nav#ac-globalnav', wait: 10, visible: true)
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
