# frozen_string_literal: true

RSpec.describe TestCentricity::WebDriverConnect, testingbot: true do
  include_context 'cloud_credentials'

  before(:context) do
    # instantiate local test environment
    @environs ||= EnvironData
    @environs.find_environ('LOCAL', :yaml)
    # load cloud services credentials into environment variables
    load_cloud_credentials
    # specify generic browser config environment variables
    ENV['SELENIUM'] = ''
    ENV['DRIVER'] = 'testingbot'
    ENV['TB_VERSION'] = 'latest'
    ENV['TB_OS'] = 'OS X'
    ENV['RESOLUTION'] = '1920x1200'
    ENV['TEST_CONTEXT'] = 'TestCentricity Web - TestingBot'
    ENV['AUTOMATE_BUILD'] = 'RSpec - Environment Variables'
  end

  let(:desired_caps_hash)  {
    {
      desired_capabilities: {
        browserName: ENV['TB_BROWSER'],
        browserVersion: ENV['TB_VERSION'],
        'bstack:options': {
          userName: ENV['TB_USERNAME'],
          accessKey: ENV['TB_AUTHKEY'],
          projectName: ENV['TEST_CONTEXT'],
          buildName: 'RSpec - DesiredCaps Hash',
          os: ENV['TB_OS'],
          osVersion: ENV['TB_OS_VERSION'],
          resolution: ENV['RESOLUTION'],
          seleniumVersion: '4.3.0'
        }
      }
    }
  }

  context 'Connect to TestingBot hosted web browsers using environment variables' do
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

    it 'connects to a Firefox browser on TestingBot' do
      ENV['TB_BROWSER'] = 'firefox'
      WebDriverConnect.initialize_web_driver
      verify_cloud_browser(browser = :firefox, platform = :desktop)
    end
  end

  context 'Connect to TestingBot hosted web browsers using desired_capabilities hash' do
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

    it 'connects to a Firefox browser on TestingBot' do
      ENV['TB_BROWSER'] = 'firefox'
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
    expect(Environ.driver).to eq(:testingbot)
    expect(Environ.device).to eq(:web)
    expect(Environ.is_web?).to eq(true)
    expect(Environ.os).to eq(ENV['TB_OS'])
  end
end
