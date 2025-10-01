# frozen_string_literal: true

RSpec.describe TestCentricity::WebDriverConnect, testingbot: true do
  include_context 'test_site'

  before(:context) do
    # load cloud services credentials into environment variables
    load_cloud_credentials
    # specify generic browser config environment variables
    ENV['DRIVER'] = 'testingbot'
    ENV['TB_VERSION'] = 'latest'
    ENV['TB_OS'] = 'MONTEREY'
    ENV['AUTOMATE_PROJECT'] = 'TestCentricity Web - TestingBot'
    ENV['TEST_CONTEXT'] = 'RSpec - Environment Variables'
    ENV['RECORD_VIDEO'] = 'true'
    ENV['TIME_ZONE'] = 'America/Los_Angeles'
    ENV['RESOLUTION'] = '2048x1536'
    ENV['BROWSER_SIZE'] = '1300, 1000'
  end

  context 'Connect to TestingBot hosted desktop web browsers using W3C desired_capabilities hash' do
    let(:desired_caps_hash)  {
      {
        driver: :testingbot,
        endpoint: "https://#{ENV['TB_USERNAME']}:#{ENV['TB_AUTHKEY']}@hub.testingbot.com/wd/hub",
        browser_size: [1400, 1100],
        capabilities: {
          browserName: ENV['TB_BROWSER'],
          browserVersion: ENV['TB_VERSION'],
          platformName: ENV['TB_OS'],
          'tb:options': {
            name: ENV['AUTOMATE_PROJECT'],
            build: 'RSpec - DesiredCaps Hash',
            timeZone: ENV['TIME_ZONE'],
            'screen-resolution': ENV['RESOLUTION'],
            'selenium-version': '4.35.0'
          }
        }
      }
    }

    it 'connects to an Edge browser on TestingBot' do
      ENV['TB_BROWSER'] = 'microsoftedge'
      WebDriverConnect.initialize_web_driver(desired_caps_hash)
      verify_cloud_browser(browser = :microsoftedge, platform = :desktop)
    end

    it 'connects to a Safari browser on TestingBot' do
      ENV['TB_BROWSER'] = 'safari'
      WebDriverConnect.initialize_web_driver(desired_caps_hash)
      verify_cloud_browser(browser = :safari, platform = :desktop)
    end

    it 'connects to a Chrome browser on TestingBot' do
      ENV['TB_BROWSER'] = 'chrome'
      WebDriverConnect.initialize_web_driver(desired_caps_hash)
      verify_cloud_browser(browser = :chrome, platform = :desktop)
    end
  end

  context 'Connect to TestingBot hosted desktop web browsers using environment variables' do
    it 'connects to an Edge browser on TestingBot' do
      ENV['TB_BROWSER'] = 'microsoftedge'
      WebDriverConnect.initialize_web_driver
      verify_cloud_browser(browser = :microsoftedge, platform = :desktop)
    end

    it 'connects to a Safari browser on TestingBot' do
      ENV['TB_BROWSER'] = 'safari'
      WebDriverConnect.initialize_web_driver
      verify_cloud_browser(browser = :safari, platform = :desktop)
    end

    it 'connects to a Chrome browser on TestingBot' do
      ENV['TB_BROWSER'] = 'chrome'
      WebDriverConnect.initialize_web_driver
      verify_cloud_browser(browser = :chrome, platform = :desktop)
    end
  end

  context 'Connect to TestingBot hosted mobile web browsers using desired_capabilities hash' do
    it 'connects to a mobile Safari browser on an iPad on TestingBot' do
      ENV['TB_OS'] = 'iOS'
      caps = {
        driver: :testingbot,
        device_type: :tablet,
        capabilities: {
          browserName: 'safari',
          browserVersion: '15.4',
          platformName: ENV['TB_OS'],
          'tb:options': {
            name: ENV['AUTOMATE_PROJECT'],
            build: 'RSpec - DesiredCaps Hash',
            deviceName: 'iPad Pro (12.9-inch) (5th generation)',
            orientation: 'LANDSCAPE',
            'selenium-version': '4.35.0'
          }
        }
      }
      WebDriverConnect.initialize_web_driver(caps)
      verify_cloud_browser(browser = :safari, platform = :mobile, device = 'iPad Pro (12.9-inch) (5th generation)')
    end

    it 'connects to a mobile Chrome browser on an Android tablet on TestingBot' do
      ENV['TB_OS'] = 'Android'
      caps = {
        driver: :testingbot,
        device_type: :tablet,
        capabilities: {
          browserName: 'Chrome',
          browserVersion: '12.0',
          platformName: ENV['TB_OS'],
          'tb:options': {
            name: ENV['AUTOMATE_PROJECT'],
            build: 'RSpec - DesiredCaps Hash',
            deviceName: 'Galaxy Tab S7',
            orientation: 'LANDSCAPE',
            'selenium-version': '4.35.0'
          }
        }
      }
      WebDriverConnect.initialize_web_driver(caps)
      verify_cloud_browser(browser = :chrome, platform = :mobile, device = 'Galaxy Tab S7')
    end
  end

  context 'Connect to TestingBot hosted mobile web browsers using environment variables' do
    it 'connects to a mobile Safari browser on an iPad on TestingBot' do
      ENV['TB_BROWSER'] = 'safari'
      ENV['TB_OS'] = 'iOS'
      ENV['TB_PLATFORM'] = 'iOS'
      ENV['TB_VERSION'] = '15.4'
      ENV['DEVICE_TYPE'] = 'tablet'
      ENV['TB_DEVICE'] = 'iPad Pro (12.9-inch) (5th generation)'
      ENV['ORIENTATION'] = 'LANDSCAPE'
      WebDriverConnect.initialize_web_driver
      verify_cloud_browser(browser = :safari, platform = :mobile, device = ENV['TB_DEVICE'])
    end

    it 'connects to a mobile Chrome browser on an Android tablet on TestingBot' do
      ENV['TB_BROWSER'] = 'Chrome'
      ENV['TB_OS'] = 'Android'
      ENV['TB_PLATFORM'] = 'Android'
      ENV['TB_VERSION'] = '12.0'
      ENV['DEVICE_TYPE'] = 'tablet'
      ENV['TB_DEVICE'] = 'Galaxy Tab S7'
      ENV['ORIENTATION'] = 'landscape'
      WebDriverConnect.initialize_web_driver
      verify_cloud_browser(browser = :chrome, platform = :mobile, device = ENV['TB_DEVICE'])
    end
  end

  after(:each) do
    WebDriverConnect.close_all_drivers
  end

  def verify_cloud_browser(browser, platform, device = nil)
    # load Apple web site
    Capybara.page.driver.browser.navigate.to(test_site_url)
    Capybara.page.find(:css, test_site_locator, wait: 10, visible: true)

    # verify Environs are correctly set
    expect(Environ.browser).to eq(browser)
    expect(Environ.platform).to eq(platform)
    expect(Environ.session_state).to eq(:running)
    expect(Environ.driver).to eq(:testingbot)
    expect(Environ.grid).to eq(:testingbot)
    expect(Environ.os).to eq(ENV['TB_OS'])
    if device
      expect(Environ.device_name).to eq(device)
      expect(Environ.is_device?).to eq(false)
      expect(Environ.is_web?).to eq(false)
      expect(Environ.device).to eq(:simulator)
      expect(Environ.device_type).to eq(:tablet)
      expect(Environ.device_orientation).to eq(:landscape)
    else
      expect(Environ.device).to eq(:web)
      expect(Environ.is_web?).to eq(true)
      expect(Environ.is_device?).to eq(false)
    end
    expect(Capybara.current_driver).to eq("testingbot_#{browser}".downcase.to_sym)
  end
end
