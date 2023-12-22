# frozen_string_literal: true

RSpec.describe TestCentricity::WebDriverConnect, browserstack: true do
  include_context 'test_site'

  before(:context) do
    # load cloud services credentials into environment variables
    load_cloud_credentials
    # specify generic browser config environment variables
    ENV['DRIVER'] = 'browserstack'
    ENV['BS_VERSION'] = 'latest'
    ENV['RESOLUTION'] = '2560x1600'
    ENV['AUTOMATE_PROJECT'] = 'TestCentricity Web - BrowserStack'
    ENV['AUTOMATE_BUILD'] = "Version #{TestCentricityWeb::VERSION}"
    ENV['TEST_CONTEXT'] = 'RSpec - Environment Variables'
    ENV['BROWSER_SIZE'] = '1300, 1000'
  end

  before(:each) do
    ENV['BS_OS'] = 'OS X'
    ENV['BS_OS_VERSION'] = 'Monterey'
  end

  context 'Connect to multiple BrowserStack hosted desktop and mobile web browsers' do
    it 'connects to multiple desktop browsers' do
      # instantiate a BrowserStack hosted desktop Chrome browser
      caps = {
        driver: :browserstack,
        browser_size: [1100, 900],
        capabilities: {
          browserName: :chrome,
          browserVersion: ENV['BS_VERSION'],
          'bstack:options': {
            userName: ENV['BS_USERNAME'],
            accessKey: ENV['BS_AUTHKEY'],
            projectName: ENV['AUTOMATE_PROJECT'],
            buildName: ENV['AUTOMATE_BUILD'],
            sessionName: 'RSpec - Multiple Desktop Browsers',
            os: ENV['BS_OS'],
            osVersion: ENV['BS_OS_VERSION'],
            resolution: ENV['RESOLUTION'],
            seleniumVersion: '4.7.2'
          }
        }
      }
      WebDriverConnect.initialize_web_driver(caps)

      # instantiate a BrowserStack hosted desktop Edge browser
      caps = {
        driver: :browserstack,
        browser_size: [1000, 800],
        capabilities: {
          browserName: :edge,
          browserVersion: ENV['BS_VERSION'],
          'bstack:options': {
            userName: ENV['BS_USERNAME'],
            accessKey: ENV['BS_AUTHKEY'],
            projectName: ENV['AUTOMATE_PROJECT'],
            buildName: ENV['AUTOMATE_BUILD'],
            sessionName: 'RSpec - Multiple Desktop Browsers',
            os: ENV['BS_OS'],
            osVersion: ENV['BS_OS_VERSION'],
            resolution: ENV['RESOLUTION'],
            seleniumVersion: '4.7.2'
          }
        }
      }
      WebDriverConnect.initialize_web_driver(caps)

      # instantiate a BrowserStack hosted desktop Firefox browser
      caps = {
        driver: :browserstack,
        browser_size: 'max',
        capabilities: {
          browserName: :firefox,
          browserVersion: ENV['BS_VERSION'],
          'bstack:options': {
            userName: ENV['BS_USERNAME'],
            accessKey: ENV['BS_AUTHKEY'],
            projectName: ENV['AUTOMATE_PROJECT'],
            buildName: ENV['AUTOMATE_BUILD'],
            sessionName: 'RSpec - Multiple Desktop Browsers',
            os: ENV['BS_OS'],
            osVersion: ENV['BS_OS_VERSION'],
            resolution: ENV['RESOLUTION'],
            seleniumVersion: '4.7.2'
          }
        }
      }
      WebDriverConnect.initialize_web_driver(caps)

      # instantiate a BrowserStack hosted desktop Safari browser
      caps = {
        driver: :browserstack,
        capabilities: {
          browserName: :safari,
          browserVersion: ENV['BS_VERSION'],
          'bstack:options': {
            userName: ENV['BS_USERNAME'],
            accessKey: ENV['BS_AUTHKEY'],
            projectName: ENV['AUTOMATE_PROJECT'],
            buildName: ENV['AUTOMATE_BUILD'],
            sessionName: 'RSpec - Multiple Desktop Browsers',
            os: ENV['BS_OS'],
            osVersion: ENV['BS_OS_VERSION'],
            resolution: ENV['RESOLUTION'],
            seleniumVersion: '4.7.2'
          }
        }
      }
      WebDriverConnect.initialize_web_driver(caps)

      # verify that 4 driver instances have been initialized
      expect(WebDriverConnect.num_drivers).to eq(4)

      # activate and verify the BrowserStack Edge desktop browser instance
      WebDriverConnect.activate_driver(:browserstack_edge)
      verify_cloud_browser(browser = :edge, platform = :desktop)

      # activate and verify the BrowserStack Safari desktop browser instance
      WebDriverConnect.activate_driver(:browserstack_safari)
      verify_cloud_browser(browser = :safari, platform = :desktop)

      # activate and verify the BrowserStack Chrome desktop browser instance
      WebDriverConnect.activate_driver(:browserstack_chrome)
      verify_cloud_browser(browser = :chrome, platform = :desktop)

      # activate and verify the BrowserStack Firefox desktop browser instance
      WebDriverConnect.activate_driver(:browserstack_firefox)
      verify_cloud_browser(browser = :firefox, platform = :desktop)
    end

    it 'connects to multiple mobile browsers' do
      # instantiate a BrowserStack hosted mobile Safari browser on an iPad
      caps = {
        driver: :browserstack,
        device_type: :tablet,
        capabilities: {
          browserName: 'Safari',
          'bstack:options': {
            userName: ENV['BS_USERNAME'],
            accessKey: ENV['BS_AUTHKEY'],
            projectName: ENV['AUTOMATE_PROJECT'],
            buildName: ENV['AUTOMATE_BUILD'],
            sessionName: 'RSpec - Multiple Mobile Browsers',
            os: 'ios',
            osVersion: '16',
            deviceName: 'iPad Pro 12.9 2022',
            deviceOrientation: 'landscape',
            appiumVersion: '1.22.0',
            realMobile: 'true'
          }
        }
      }
      WebDriverConnect.initialize_web_driver(caps)

      # instantiate a BrowserStack hosted mobile Chrome browser on an Android tablet
      caps = {
        driver: :browserstack,
        device_type: :tablet,
        capabilities: {
          browserName: 'Chrome',
          'bstack:options': {
            userName: ENV['BS_USERNAME'],
            accessKey: ENV['BS_AUTHKEY'],
            projectName: ENV['AUTOMATE_PROJECT'],
            buildName: ENV['AUTOMATE_BUILD'],
            sessionName: 'RSpec - Multiple Mobile Browsers',
            os: 'android',
            osVersion: '12.0',
            deviceName: 'Samsung Galaxy Tab S8',
            deviceOrientation: 'landscape',
            appiumVersion: '1.22.0',
            realMobile: 'true'
          }
        }
      }
      WebDriverConnect.initialize_web_driver(caps)

      # verify that 2 driver instances have been initialized
      expect(WebDriverConnect.num_drivers).to eq(2)

      # activate and verify the BrowserStack mobile Safari browser on an iPad
      WebDriverConnect.activate_driver(:browserstack_safari)
      verify_cloud_browser(browser = :safari, platform = :mobile, device = 'iPad Pro 12.9 2022')

      # activate and verify the BrowserStack mobile Chrome browser on an Android tablet
      WebDriverConnect.activate_driver(:browserstack_chrome)
      verify_cloud_browser(browser = :chrome, platform = :mobile, device = 'Samsung Galaxy Tab S8')
    end
  end

  context 'Connect to BrowserStack hosted desktop web browsers using W3C desired_capabilities hash' do
    let(:desktop_caps_hash) {
      {
        driver: :browserstack,
        endpoint: "https://#{ENV['BS_USERNAME']}:#{ENV['BS_AUTHKEY']}@hub-cloud.browserstack.com/wd/hub",
        browser_size: [1400, 1100],
        capabilities: {
          browserName: ENV['BS_BROWSER'],
          browserVersion: ENV['BS_VERSION'],
          'bstack:options': {
            userName: ENV['BS_USERNAME'],
            accessKey: ENV['BS_AUTHKEY'],
            projectName: ENV['AUTOMATE_PROJECT'],
            buildName: ENV['AUTOMATE_BUILD'],
            sessionName: 'RSpec - DesiredCaps Hash',
            os: ENV['BS_OS'],
            osVersion: ENV['BS_OS_VERSION'],
            resolution: ENV['RESOLUTION'],
            seleniumVersion: '4.15.0'
          }
        }
      }
    }

    it 'connects to an Edge browser on BrowserStack' do
      ENV['BS_BROWSER'] = 'Edge'
      WebDriverConnect.initialize_web_driver(desktop_caps_hash)
      verify_cloud_browser(browser = :edge, platform = :desktop)
    end

    it 'connects to a Safari browser on BrowserStack' do
      ENV['BS_BROWSER'] = 'Safari'
      WebDriverConnect.initialize_web_driver(desktop_caps_hash)
      verify_cloud_browser(browser = :safari, platform = :desktop)
    end

    it 'connects to a Chrome browser on BrowserStack' do
      ENV['BS_BROWSER'] = 'Chrome'
      WebDriverConnect.initialize_web_driver(desktop_caps_hash)
      verify_cloud_browser(browser = :chrome, platform = :desktop)
    end

    it 'connects to a Firefox browser on BrowserStack' do
      ENV['BS_BROWSER'] = 'Firefox'
      WebDriverConnect.initialize_web_driver(desktop_caps_hash)
      verify_cloud_browser(browser = :firefox, platform = :desktop)
    end

    it 'connects to an IE browser on BrowserStack' do
      ENV['BS_BROWSER'] = 'IE'
      ENV['BS_OS'] = 'Windows'
      ENV['BS_OS_VERSION'] = '10'
      WebDriverConnect.initialize_web_driver(desktop_caps_hash)
      verify_cloud_browser(browser = :ie, platform = :desktop)
    end
  end

  context 'Connect to BrowserStack hosted desktop web browsers using environment variables' do
    it 'connects to an Edge browser on BrowserStack' do
      ENV['BS_BROWSER'] = 'Edge'
      WebDriverConnect.initialize_web_driver
      verify_cloud_browser(browser = :edge, platform = :desktop)
    end

    it 'connects to a Safari browser on BrowserStack' do
      ENV['BS_BROWSER'] = 'Safari'
      WebDriverConnect.initialize_web_driver
      verify_cloud_browser(browser = :safari, platform = :desktop)
    end

    it 'connects to a Chrome browser on BrowserStack' do
      ENV['BS_BROWSER'] = 'Chrome'
      WebDriverConnect.initialize_web_driver
      verify_cloud_browser(browser = :chrome, platform = :desktop)
    end

    it 'connects to a Firefox browser on BrowserStack' do
      ENV['BS_BROWSER'] = 'Firefox'
      WebDriverConnect.initialize_web_driver
      verify_cloud_browser(browser = :firefox, platform = :desktop)
    end

    it 'connects to an IE browser on BrowserStack' do
      ENV['BS_BROWSER'] = 'IE'
      ENV['BS_OS'] = 'Windows'
      ENV['BS_OS_VERSION'] = '10'
      WebDriverConnect.initialize_web_driver
      verify_cloud_browser(browser = :ie, platform = :desktop)
    end
  end

  context 'Connect to BrowserStack hosted mobile web browsers using desired_capabilities hash' do
    it 'connects to a mobile Safari browser on an iPad on BrowserStack' do
      ENV['BS_OS'] = 'ios'
      ENV['BS_OS_VERSION'] = '15'
      caps = {
        driver: :browserstack,
        device_type: :tablet,
        capabilities: {
          browserName: 'Safari',
          'bstack:options': {
            userName: ENV['BS_USERNAME'],
            accessKey: ENV['BS_AUTHKEY'],
            projectName: ENV['AUTOMATE_PROJECT'],
            buildName: ENV['AUTOMATE_BUILD'],
            sessionName: 'RSpec - DesiredCaps Hash',
            os: ENV['BS_OS'],
            osVersion: ENV['BS_OS_VERSION'],
            deviceName: 'iPad Pro 12.9 2018',
            deviceOrientation: 'landscape',
            appiumVersion: '1.22.0',
            realMobile: 'true'
          }
        }
      }
      WebDriverConnect.initialize_web_driver(caps)
      verify_cloud_browser(browser = :safari, platform = :mobile, device = 'iPad Pro 12.9 2018')
    end

    it 'connects to a mobile Chrome browser on an Android tablet on BrowserStack' do
      ENV['BS_OS'] = 'android'
      ENV['BS_OS_VERSION'] = '10.0'
      caps = {
        driver: :browserstack,
        device_type: :tablet,
        capabilities: {
          browserName: 'Chrome',
          'bstack:options': {
            userName: ENV['BS_USERNAME'],
            accessKey: ENV['BS_AUTHKEY'],
            projectName: ENV['AUTOMATE_PROJECT'],
            buildName: ENV['AUTOMATE_BUILD'],
            sessionName: 'RSpec - DesiredCaps Hash',
            os: ENV['BS_OS'],
            osVersion: ENV['BS_OS_VERSION'],
            deviceName: 'Samsung Galaxy Tab S7',
            deviceOrientation: 'landscape',
            appiumVersion: '1.22.0',
            realMobile: 'true'
          }
        }
      }
      WebDriverConnect.initialize_web_driver(caps)
      verify_cloud_browser(browser = :chrome, platform = :mobile, device = 'Samsung Galaxy Tab S7')
    end
  end

  context 'Connect to BrowserStack hosted mobile web browsers using environment variables' do
    it 'connects to a mobile Safari browser on an iPad on BrowserStack' do
      ENV['BS_BROWSER'] = 'Safari'
      ENV['BS_OS'] = 'ios'
      ENV['BS_OS_VERSION'] = '15'
      ENV['BS_REAL_MOBILE'] = 'true'
      ENV['DEVICE_TYPE'] = 'tablet'
      ENV['BS_DEVICE'] = 'iPad Pro 12.9 2018'
      ENV['ORIENTATION'] = 'landscape'
      WebDriverConnect.initialize_web_driver
      verify_cloud_browser(browser = :safari, platform = :mobile, device = ENV['BS_DEVICE'])
    end

    it 'connects to a mobile Chrome browser on an Android tablet on BrowserStack' do
      ENV['BS_BROWSER'] = 'Chrome'
      ENV['BS_OS'] = 'android'
      ENV['BS_OS_VERSION'] = '10.0'
      ENV['BS_REAL_MOBILE'] = 'true'
      ENV['DEVICE_TYPE'] = 'tablet'
      ENV['BS_DEVICE'] = 'Samsung Galaxy Tab S7'
      ENV['ORIENTATION'] = 'landscape'
      WebDriverConnect.initialize_web_driver
      verify_cloud_browser(browser = :chrome, platform = :mobile, device = ENV['BS_DEVICE'])
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
    expect(Environ.driver).to eq(:browserstack)
    expect(Environ.grid).to eq(:browserstack)
    if device
      expect(Environ.device_name).to eq(device)
      expect(Environ.device).to eq(:device)
      expect(Environ.device_type).to eq(:tablet)
      expect(Environ.device_orientation).to eq(:landscape)
      expect(Environ.is_device?).to eq(true)
      expect(Environ.is_web?).to eq(false)
    else
      expect(Environ.device).to eq(:web)
      expect(Environ.is_web?).to eq(true)
      expect(Environ.is_device?).to eq(false)
    end
    expect(Capybara.current_driver).to eq("browserstack_#{browser}".downcase.to_sym)
  end
end
