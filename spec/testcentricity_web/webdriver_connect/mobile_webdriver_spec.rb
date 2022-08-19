# frozen_string_literal: true

RSpec.describe TestCentricity::WebDriverConnect, mobile: true do
  before(:context) do
    # instantiate local test environment
    @environs ||= EnvironData
    @environs.find_environ('LOCAL', :yaml)
    ENV['SELENIUM'] = ''
    ENV['DRIVER'] = 'appium'
    ENV['DEVICE_TYPE'] = 'tablet'
    # start Appium server
    $server = TestCentricity::AppiumServer.new
    $server.start
  end

  context 'Mobile device simulator' do
    it 'connects to iOS Simulator - environment variables' do
      ENV['AUTOMATION_ENGINE'] = 'XCUITest'
      ENV['APP_PLATFORM_NAME'] = 'ios'
      ENV['APP_BROWSER'] = 'Safari'
      ENV['APP_VERSION'] = '15.4'
      ENV['APP_DEVICE'] = 'iPad Pro (12.9-inch) (5th generation)'
      WebDriverConnect.initialize_web_driver
      verify_mobile_browser(browser = :safari, device_os = :ios)
    end

    it 'connects to iOS Simulator - desired_capabilities hash' do
      ENV['APP_PLATFORM_NAME'] = 'ios'
      ENV['APP_BROWSER'] = 'Safari'
      ENV['APP_VERSION'] = '15.4'
      ENV['APP_DEVICE'] = 'iPad Pro (12.9-inch) (5th generation)'

      caps = {
        desired_capabilities: {
          platformName: ENV['APP_PLATFORM_NAME'],
          platformVersion: ENV['APP_VERSION'],
          browserName: ENV['APP_BROWSER'],
          deviceName: ENV['APP_DEVICE'],
          automationName: 'XCUITest'
        }
      }
      WebDriverConnect.initialize_web_driver(caps)
      verify_mobile_browser(browser = :safari, device_os = :ios)
    end

    it 'connects to Android Simulator - environment variables' do
      ENV['APP_PLATFORM_NAME'] = 'Android'
      ENV['APP_BROWSER'] = 'Chrome'
      ENV['APP_VERSION'] = '12.0'
      ENV['APP_DEVICE'] = 'Pixel_C_API_31'
      WebDriverConnect.initialize_web_driver
      verify_mobile_browser(browser = :chrome, device_os = :android)
    end

    it 'connects to Android Simulator - desired_capabilities hash' do
      ENV['APP_PLATFORM_NAME'] = 'Android'
      ENV['APP_BROWSER'] = 'Chrome'
      ENV['APP_VERSION'] = '12.0'
      ENV['APP_DEVICE'] = 'Pixel_C_API_31'

      caps = {
        desired_capabilities: {
          platformName: ENV['APP_PLATFORM_NAME'],
          platformVersion: ENV['APP_VERSION'],
          browserName: ENV['APP_BROWSER'],
          deviceName: ENV['APP_DEVICE'],
          automationName: 'Android'
        }
      }
      WebDriverConnect.initialize_web_driver(caps)
      verify_mobile_browser(browser = :chrome, device_os = :android)
    end
  end

  def verify_mobile_browser(browser, device_os)
    expect(Environ.browser).to eq(browser)
    expect(Environ.device_os).to eq(device_os)
    expect(Environ.platform).to eq(:mobile)
    expect(Environ.headless).to eq(false)
    expect(Environ.session_state).to eq(:running)
    expect(Environ.driver).to eq(:appium)
    expect(Environ.device).to eq(:simulator)
    expect(Environ.device_type).to eq(:tablet)
    expect(Environ.is_web?).to eq(false)
    expect(Environ.device_name).to eq(ENV['APP_DEVICE'])
    expect(Environ.device_os_version).to eq(ENV['APP_VERSION'])
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
