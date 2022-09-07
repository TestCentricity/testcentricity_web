# frozen_string_literal: true

RSpec.describe TestCentricity::WebDriverConnect, mobile: true do
  before(:context) do
    ENV['SELENIUM'] = ''
    ENV['DEVICE_TYPE'] = 'tablet'
    # start Appium server
    $server = TestCentricity::AppiumServer.new
    $server.start
  end

  context 'Connect to locally hosted mobile device simulator using desired_capabilities hash' do
    it 'connects to iOS Simulator - desired_capabilities hash' do
      caps = {
        driver: :appium,
        endpoint: 'http://localhost:4723/wd/hub',
        desired_capabilities: {
          platformName: 'ios',
          platformVersion: '15.4',
          browserName: 'Safari',
          deviceName: 'iPad Pro (12.9-inch) (5th generation)',
          automationName: 'XCUITest',
          orientation: 'LANDSCAPE'
        }
      }
      WebDriverConnect.initialize_web_driver(caps)
      verify_mobile_browser(browser = :safari, device_os = :ios)
      expect(Environ.device_name).to eq('iPad Pro (12.9-inch) (5th generation)')
      expect(Environ.device_os_version).to eq('15.4')
    end

    it 'connects to Android Simulator - desired_capabilities hash' do
      caps = {
        driver: :appium,
        desired_capabilities: {
          platformName: 'Android',
          platformVersion: '12.0',
          browserName: 'Chrome',
          deviceName: 'Pixel_C_API_31',
          avd: 'Pixel_C_API_31',
          automationName: 'UiAutomator2',
          orientation: 'PORTRAIT'
        }
      }
      WebDriverConnect.initialize_web_driver(caps)
      verify_mobile_browser(browser = :chrome, device_os = :android)
      expect(Environ.device_name).to eq('Pixel_C_API_31')
      expect(Environ.device_os_version).to eq('12.0')
    end
  end

  context 'Connect to locally hosted mobile device simulator using environment variables' do
    it 'connects to iOS Simulator - environment variables' do
      ENV['DRIVER'] = 'appium'
      ENV['AUTOMATION_ENGINE'] = 'XCUITest'
      ENV['APP_PLATFORM_NAME'] = 'ios'
      ENV['APP_BROWSER'] = 'Safari'
      ENV['APP_VERSION'] = '15.4'
      ENV['APP_DEVICE'] = 'iPad Pro (12.9-inch) (5th generation)'
      ENV['ORIENTATION'] = 'portrait'
      WebDriverConnect.initialize_web_driver
      verify_mobile_browser(browser = :safari, device_os = :ios)
      expect(Environ.device_name).to eq(ENV['APP_DEVICE'])
      expect(Environ.device_os_version).to eq(ENV['APP_VERSION'])
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
    end
  end

  def verify_mobile_browser(browser, device_os)
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
    expect(Environ.device_type).to eq(:tablet)
    expect(Environ.is_web?).to eq(false)
    if device_os == :ios
      expect(Environ.is_ios?).to eq(true)
    else
      expect(Environ.is_android?).to eq(true)
    end
  end

  after(:each) do
    Capybara.current_session.quit
    Environ.session_state = :quit
  end

  after(:context) do
    $server.stop if Environ.driver == :appium && $server.running?
  end
end
