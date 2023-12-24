# frozen_string_literal: true

RSpec.describe TestCentricity::WebDriverConnect, saucelabs: true do
  include_context 'test_site'

  before(:context) do
    # load cloud services credentials into environment variables
    load_cloud_credentials
    # specify generic browser config environment variables
    ENV['DRIVER'] = 'saucelabs'
    ENV['SL_DATA_CENTER'] = 'us-west-1'
    ENV['SL_VERSION'] = 'latest'
    ENV['SL_OS'] = 'macOS 13'
    ENV['AUTOMATE_PROJECT'] = 'TestCentricity Web - SauceLabs'
    ENV['TEST_CONTEXT'] = "Version #{TestCentricityWeb::VERSION}"
    ENV['RESOLUTION'] = '2048x1536'
    ENV['BROWSER_SIZE'] = '1300, 1000'
  end

  context 'Connect to SauceLabs hosted desktop web browsers using environment variables' do
    it 'connects to a Safari browser on SauceLabs' do
      ENV['SL_BROWSER'] = 'Safari'
      WebDriverConnect.initialize_web_driver
      verify_cloud_browser(browser = :safari, platform = :desktop)
    end

    it 'connects to a Chrome browser on SauceLabs' do
      ENV['SL_BROWSER'] = 'Chrome'
      WebDriverConnect.initialize_web_driver
      verify_cloud_browser(browser = :chrome, platform = :desktop)
    end

    it 'connects to a Firefox browser on SauceLabs' do
      ENV['SL_BROWSER'] = 'Firefox'
      WebDriverConnect.initialize_web_driver
      verify_cloud_browser(browser = :firefox, platform = :desktop)
    end

    it 'connects to an Edge browser on SauceLabs' do
      ENV['SL_BROWSER'] = 'MicrosoftEdge'
      WebDriverConnect.initialize_web_driver
      verify_cloud_browser(browser = :microsoftedge, platform = :desktop)
    end
  end

  context 'Connect to SauceLabs hosted desktop web browsers using W3C desired_capabilities hash' do
    let(:desktop_caps_hash) {
      {
        driver: :saucelabs,
        endpoint: "https://#{ENV['SL_USERNAME']}:#{ENV['SL_AUTHKEY']}@ondemand.#{ENV['SL_DATA_CENTER']}.saucelabs.com:443/wd/hub",
        browser_size: [1400, 1100],
        capabilities: {
          browserName: ENV['SL_BROWSER'],
          browser_version: ENV['SL_VERSION'],
          platform_name: ENV['SL_OS'],
          'sauce:options': {
            username: ENV['SL_USERNAME'],
            access_key: ENV['SL_AUTHKEY'],
            name: ENV['AUTOMATE_PROJECT'],
            build: ENV['TEST_CONTEXT'],
            screenResolution: ENV['RESOLUTION']
          }
        }
      }
    }

    it 'connects to a Safari browser on SauceLabs' do
      ENV['SL_BROWSER'] = 'Safari'
      WebDriverConnect.initialize_web_driver(desktop_caps_hash)
      verify_cloud_browser(browser = :safari, platform = :desktop)
    end

    it 'connects to a Chrome browser on SauceLabs' do
      ENV['SL_BROWSER'] = 'Chrome'
      WebDriverConnect.initialize_web_driver(desktop_caps_hash)
      verify_cloud_browser(browser = :chrome, platform = :desktop)
    end

    it 'connects to a Firefox browser on SauceLabs' do
      ENV['SL_BROWSER'] = 'Firefox'
      WebDriverConnect.initialize_web_driver(desktop_caps_hash)
      verify_cloud_browser(browser = :firefox, platform = :desktop)
    end

    it 'connects to an Edge browser on SauceLabs' do
      ENV['SL_BROWSER'] = 'MicrosoftEdge'
      WebDriverConnect.initialize_web_driver(desktop_caps_hash)
      verify_cloud_browser(browser = :microsoftedge, platform = :desktop)
    end
  end

  context 'Connect to SauceLabs hosted mobile web browsers using environment variables' do
    it 'connects to a mobile Safari browser on an iPad on SauceLabs' do
      ENV['SL_BROWSER'] = 'Safari'
      ENV['SL_PLATFORM'] = 'iOS'
      ENV['SL_VERSION'] = '15.4'
      ENV['DEVICE_TYPE'] = 'tablet'
      ENV['SL_DEVICE'] = 'iPad Pro (12.9 inch) (5th generation) Simulator'
      ENV['AUTOMATION_ENGINE'] = 'XCUITest'
      ENV['ORIENTATION'] = 'landscape'
      WebDriverConnect.initialize_web_driver
      verify_cloud_browser(browser = :safari, platform = :mobile, device = ENV['SL_DEVICE'])
    end

    it 'connects to a mobile Chrome browser on an Android tablet on SauceLabs' do
      ENV['SL_BROWSER'] = 'Chrome'
      ENV['SL_PLATFORM'] = 'Android'
      ENV['SL_VERSION'] = '12.0'
      ENV['DEVICE_TYPE'] = 'tablet'
      ENV['SL_DEVICE'] = 'Samsung Galaxy Tab S7 Plus GoogleAPI Emulator'
      ENV['AUTOMATION_ENGINE'] = 'UiAutomator2'
      ENV['ORIENTATION'] = 'landscape'
      WebDriverConnect.initialize_web_driver
      verify_cloud_browser(browser = :chrome, platform = :mobile, device = ENV['SL_DEVICE'])
    end
  end

  context 'Connect to SauceLabs hosted mobile web browsers using W3C desired_capabilities hash' do
    it 'connects to a mobile Safari browser on an iPad on SauceLabs' do
      caps = {
        driver: :saucelabs,
        device_type: :tablet,
        capabilities: {
          browserName: 'Safari',
          platform_name: 'iOS',
          'appium:automationName': 'XCUITest',
          'appium:platformVersion': '15.4',
          'appium:deviceName': 'iPad Pro (12.9 inch) (5th generation) Simulator',
          'sauce:options': {
            username: ENV['SL_USERNAME'],
            access_key: ENV['SL_AUTHKEY'],
            name: ENV['AUTOMATE_PROJECT'],
            build: ENV['TEST_CONTEXT'],
            deviceOrientation: 'landscape',
            appiumVersion: '1.22.3'
          }
        }
      }
      WebDriverConnect.initialize_web_driver(caps)
      verify_cloud_browser(browser = :safari,
                           platform = :mobile,
                           device = 'iPad Pro (12.9 inch) (5th generation) Simulator')
    end

    it 'connects to a mobile Chrome browser on an Android tablet on SauceLabs' do
      caps = {
        driver: :saucelabs,
        device_type: :tablet,
        capabilities: {
          browserName: 'Chrome',
          platform_name: 'Android',
          'appium:automationName': 'UiAutomator2',
          'appium:platformVersion': '12.0',
          'appium:deviceName': 'Samsung Galaxy Tab S7 Plus GoogleAPI Emulator',
          'sauce:options': {
            username: ENV['SL_USERNAME'],
            access_key: ENV['SL_AUTHKEY'],
            name: ENV['AUTOMATE_PROJECT'],
            build: ENV['TEST_CONTEXT'],
            deviceOrientation: 'landscape',
            appiumVersion: '1.22.3'
          }
        }
      }
      WebDriverConnect.initialize_web_driver(caps)
      verify_cloud_browser(browser = :chrome,
                           platform = :mobile,
                           device = 'Samsung Galaxy Tab S7 Plus GoogleAPI Emulator')
    end
  end

  after(:each) do
    WebDriverConnect.close_all_drivers
    # verify that all driver instances have been closed
    expect(WebDriverConnect.num_drivers).to eq(0)
  end

  def verify_cloud_browser(browser, platform, device = nil)
    # load Apple web site
    Capybara.page.driver.browser.navigate.to(test_site_url)
    Capybara.page.find(:css, test_site_locator, wait: 10, visible: true)
    # verify Environs are correctly set
    expect(Environ.browser).to eq(browser)
    expect(Environ.platform).to eq(platform)
    expect(Environ.session_state).to eq(:running)
    expect(Environ.driver).to eq(:saucelabs)
    expect(Environ.grid).to eq(:saucelabs)
    if device
      expect(Environ.device_name).to eq(device)
      expect(Environ.device).to eq(:simulator)
      expect(Environ.device_type).to eq(:tablet)
      expect(Environ.device_orientation).to eq(:landscape)
      expect(Environ.is_simulator?).to eq(true)
      expect(Environ.is_web?).to eq(false)
    else
      expect(Environ.device).to eq(:web)
      expect(Environ.is_web?).to eq(true)
      expect(Environ.is_device?).to eq(false)
    end
    expect(Capybara.current_driver).to eq("saucelabs_#{browser}".downcase.to_sym)
  end
end
