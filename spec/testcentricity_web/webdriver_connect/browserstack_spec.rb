# frozen_string_literal: true

RSpec.describe TestCentricity::WebDriverConnect, browserstack: true do
  include_context 'cloud_credentials'

  before(:context) do
    # instantiate local test environment
    @environs ||= EnvironData
    @environs.find_environ('LOCAL', :yaml)
    # load cloud services credentials into environment variables
    load_cloud_credentials
    # specify generic browser config environment variables
    ENV['SELENIUM'] = ''
    ENV['DRIVER'] = 'browserstack'
    ENV['BS_VERSION'] = 'latest'
    ENV['BS_OS'] = 'OS X'
    ENV['BS_OS_VERSION'] = 'Monterey'
    ENV['RESOLUTION'] = '1920x1080'
    ENV['TEST_CONTEXT'] = 'TestCentricity Web - BrowserStack'
    ENV['AUTOMATE_BUILD'] = 'RSpec - Environment Variables'
  end

  let(:desired_caps_hash)  {
    {
      desired_capabilities: {
        browserName: ENV['BS_BROWSER'],
        browserVersion: ENV['BS_VERSION'],
        'bstack:options': {
          userName: ENV['BS_USERNAME'],
          accessKey: ENV['BS_AUTHKEY'],
          projectName: ENV['TEST_CONTEXT'],
          buildName: 'RSpec - DesiredCaps Hash',
          os: ENV['BS_OS'],
          osVersion: ENV['BS_OS_VERSION'],
          resolution: ENV['RESOLUTION'],
          seleniumVersion: '4.3.0'
        }
      }
    }
  }

  context 'Connect to BrowserStack hosted web browsers using environment variables' do
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
  end

  context 'Connect to BrowserStack hosted web browsers using desired_capabilities hash' do
    it 'connects to an Edge browser on BrowserStack' do
      ENV['BS_BROWSER'] = 'Edge'
      WebDriverConnect.initialize_web_driver(desired_caps_hash)
      verify_cloud_browser(browser = :edge, platform = :desktop)
    end

    it 'connects to a Safari browser on BrowserStack' do
      ENV['BS_BROWSER'] = 'Safari'
      WebDriverConnect.initialize_web_driver(desired_caps_hash)
      verify_cloud_browser(browser = :safari, platform = :desktop)
    end

    it 'connects to a Chrome browser on BrowserStack' do
      ENV['BS_BROWSER'] = 'Chrome'
      WebDriverConnect.initialize_web_driver(desired_caps_hash)
      verify_cloud_browser(browser = :chrome, platform = :desktop)
    end

    it 'connects to a Firefox browser on BrowserStack' do
      ENV['BS_BROWSER'] = 'Firefox'
      WebDriverConnect.initialize_web_driver(desired_caps_hash)
      verify_cloud_browser(browser = :firefox, platform = :desktop)
    end
  end

  after(:each) do
    Capybara.page.driver.quit
    Capybara.current_session.quit
    Capybara.reset_sessions!
    Environ.session_state = :quit
  end

  def verify_cloud_browser(browser, platform)
    expect(Environ.browser).to eq(browser)
    expect(Environ.platform).to eq(platform)
    expect(Environ.session_state).to eq(:running)
    expect(Environ.driver).to eq(:browserstack)
    expect(Environ.device).to eq(:web)
    expect(Environ.is_web?).to eq(true)
    expect(Environ.os).to eq("#{ENV['BS_OS']} #{ENV['BS_OS_VERSION']}")
  end
end
