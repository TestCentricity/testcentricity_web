# frozen_string_literal: true

RSpec.describe TestCentricity::WebDriverConnect, custom: true do
  include_context 'test_site'

  before(:context) do
    # load cloud services credentials into environment variables
    load_cloud_credentials
  end

  context 'Connect to user-defined web browsers using W3C desired_capabilities hash' do
    it 'raises exception when no capabilities are defined' do
      options = {
        driver: :custom,
        driver_name: :custom_no_caps,
        endpoint: "https://#{ENV['TB_USERNAME']}:#{ENV['TB_AUTHKEY']}@hub.testingbot.com/wd/hub",
      }
      expect { WebDriverConnect.initialize_web_driver(options) }.to raise_error('User-defined webdriver requires that you provide capabilities')
    end

    it 'raises exception when no endpoint is defined' do
      options = {
        driver: :custom,
        driver_name: :custom_no_endpoint,
        browser_size: [1400, 1100],
        capabilities: {
          browserName: 'microsoftedge',
          browser_version: 'latest',
          platform_name: 'MONTEREY',
          'tb:options': {
            name: 'TestCentricity Web - Custom WebDriver',
            build: "Version #{TestCentricityWeb::VERSION}",
            'screen-resolution': '2048x1536',
            'selenium-version': '4.14.1'
          }
        }
      }
      expect { WebDriverConnect.initialize_web_driver(options) }.to raise_error('User-defined webdriver requires that you provide an endpoint')
    end

    it 'connects to an Edge desktop browser on TestingBot' do
      Environ.platform = :desktop
      Environ.device = :web
      options = {
        driver: :custom,
        browser_size: [1400, 1100],
        endpoint: "https://#{ENV['TB_USERNAME']}:#{ENV['TB_AUTHKEY']}@hub.testingbot.com/wd/hub",
        capabilities: {
          browserName: 'microsoftedge',
          browser_version: 'latest',
          platform_name: 'MONTEREY',
          'tb:options': {
            name: 'TestCentricity Web - Custom WebDriver',
            build: "Version #{TestCentricityWeb::VERSION}",
            'screen-resolution': '2048x1536',
            'selenium-version': '4.28.0'
          }
        }
      }
      WebDriverConnect.initialize_web_driver(options)
      verify_custom_browser(browser = :microsoftedge, platform = :desktop)
    end

    it 'connects to a Safari desktop browser on BrowserStack' do
      Environ.platform = :desktop
      Environ.device = :web
      options = {
        driver: :custom,
        driver_name: :custom_browserstack,
        browser_size: [1400, 1100],
        endpoint: "https://#{ENV['BS_USERNAME']}:#{ENV['BS_AUTHKEY']}@hub-cloud.browserstack.com/wd/hub",
        capabilities: {
          browserName: 'Safari',
          browser_version: 'latest',
          'bstack:options': {
            userName: ENV['BS_USERNAME'],
            accessKey: ENV['BS_AUTHKEY'],
            projectName: 'TestCentricity Web - Custom WebDriver',
            buildName: "Version #{TestCentricityWeb::VERSION}",
            sessionName: 'RSpec - Custom WebDriver',
            os: 'OS X',
            osVersion: 'Sonoma',
            resolution: '3840x2160',
            seleniumVersion: '4.27.0'
          }
        }
      }
      WebDriverConnect.initialize_web_driver(options)
      verify_custom_browser(browser = :safari, platform = :desktop)
    end

    it 'connects to a Safari mobile browser on BrowserStack' do
      Environ.platform = :mobile
      Environ.device = :device
      Environ.device_name = 'iPad Pro 12.9 2022'
      options = {
        driver: :custom,
        driver_name: :custom_bs_mobile,
        device_type: :tablet,
        endpoint: "https://#{ENV['BS_USERNAME']}:#{ENV['BS_AUTHKEY']}@hub-cloud.browserstack.com/wd/hub",
        capabilities: {
          browserName: 'Safari',
          'bstack:options': {
            userName: ENV['BS_USERNAME'],
            accessKey: ENV['BS_AUTHKEY'],
            projectName: 'TestCentricity Web - Custom WebDriver',
            buildName: "Version #{TestCentricityWeb::VERSION}",
            sessionName: 'RSpec - Custom WebDriver',
            os: 'ios',
            osVersion: '16',
            deviceName: Environ.device_name,
            appiumVersion: '2.6.0',
            realMobile: 'true'
          }
        }
      }
      WebDriverConnect.initialize_web_driver(options)
      verify_custom_browser(browser = :safari, platform = :mobile, device = 'iPad Pro 12.9 2022')
    end
  end

  after(:each) do
    WebDriverConnect.close_all_drivers
  end


  def verify_custom_browser(browser, platform, device = nil)
    # load Apple web site
    Capybara.page.driver.browser.navigate.to(test_site_url)
    Capybara.page.find(:css, test_site_locator, wait: 10, visible: true)
    # verify Environs are correctly set
    expect(Environ.browser).to eq(browser)
    expect(Environ.platform).to eq(platform)
    expect(Environ.session_state).to eq(:running)
    expect(Environ.driver).to eq(:custom)
    expect(Environ.grid).to eq(:custom)
    if device
      expect(Environ.device_name).to eq(device)
      expect(Environ.device).to eq(:device)
      expect(Environ.device_type).to eq(:tablet)
      expect(Environ.is_device?).to eq(true)
      expect(Environ.is_web?).to eq(false)
    else
      expect(Environ.device).to eq(:web)
      expect(Environ.is_web?).to eq(true)
      expect(Environ.is_device?).to eq(false)
    end
    expect(Capybara.current_driver).to eq(Environ.driver_name)
  end
end
