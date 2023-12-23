# frozen_string_literal: true

RSpec.describe TestCentricity::WebDriverConnect, lambdatest: true do
  include_context 'test_site'

  before(:context) do
    # load cloud services credentials into environment variables
    load_cloud_credentials
    # specify generic browser config environment variables
    ENV['DRIVER'] = 'lambdatest'
    ENV['LT_VERSION'] = 'latest'
    ENV['LT_OS'] = 'macOS Sonoma'
    ENV['AUTOMATE_PROJECT'] = 'TestCentricity Web - LambdaTest'
    ENV['AUTOMATE_BUILD'] = "Version #{TestCentricityWeb::VERSION}"
    ENV['TEST_CONTEXT'] = 'RSpec - Environment Variables'
    ENV['RESOLUTION'] = '2560x1440'
    ENV['BROWSER_SIZE'] = '1300, 1000'
  end

  context 'Connect to LambdaTest hosted desktop web browsers using W3C desired_capabilities hash' do
    let(:desktop_caps_hash) {
      {
        driver: :lambdatest,
        endpoint: "https://#{ENV['LT_USERNAME']}:#{ENV['LT_AUTHKEY']}@hub.lambdatest.com/wd/hub",
        browser_size: [1400, 1100],
        capabilities: {
          browserName: ENV['LT_BROWSER'],
          browserVersion: ENV['LT_VERSION'],
          'LT:Options': {
            username: ENV['LT_USERNAME'],
            accessKey: ENV['LT_AUTHKEY'],
            project: ENV['AUTOMATE_PROJECT'],
            build: ENV['AUTOMATE_BUILD'],
            name: 'RSpec - DesiredCaps Hash',
            platformName: ENV['LT_OS'],
            resolution: ENV['RESOLUTION'],
            video: true
          }
        }
      }
    }

    it 'connects to an Edge browser on LambdaTest' do
      ENV['LT_BROWSER'] = 'MicrosoftEdge'
      WebDriverConnect.initialize_web_driver(desktop_caps_hash)
      verify_cloud_browser(browser = :microsoftedge)
    end

    it 'connects to a Safari browser on LambdaTest' do
      ENV['LT_BROWSER'] = 'Safari'
      WebDriverConnect.initialize_web_driver(desktop_caps_hash)
      verify_cloud_browser(browser = :safari)
    end

    it 'connects to a Chrome browser on LambdaTest' do
      ENV['LT_BROWSER'] = 'Chrome'
      WebDriverConnect.initialize_web_driver(desktop_caps_hash)
      verify_cloud_browser(browser = :chrome)
    end

    it 'connects to a Firefox browser on LambdaTest' do
      ENV['LT_BROWSER'] = 'Firefox'
      WebDriverConnect.initialize_web_driver(desktop_caps_hash)
      verify_cloud_browser(browser = :firefox)
    end

    it 'connects to an IE browser on LambdaTest' do
      ENV['LT_BROWSER'] = 'Internet Explorer'
      ENV['LT_OS'] = 'Windows 10'
      WebDriverConnect.initialize_web_driver(desktop_caps_hash)
      verify_cloud_browser(browser = :internet_explorer)
    end
  end

  context 'Connect to LambdaTest hosted desktop web browsers using environment variables' do
    it 'connects to an Edge browser on LambdaTest' do
      ENV['BS_BROWSER'] = 'Edge'
      WebDriverConnect.initialize_web_driver
      verify_cloud_browser(browser = :microsoftedge)
    end

    it 'connects to a Safari browser on LambdaTest' do
      ENV['BS_BROWSER'] = 'Safari'
      WebDriverConnect.initialize_web_driver
      verify_cloud_browser(browser = :safari)
    end

    it 'connects to a Chrome browser on LambdaTest' do
      ENV['BS_BROWSER'] = 'Chrome'
      WebDriverConnect.initialize_web_driver
      verify_cloud_browser(browser = :chrome)
    end

    it 'connects to a Firefox browser on LambdaTest' do
      ENV['BS_BROWSER'] = 'Firefox'
      WebDriverConnect.initialize_web_driver
      verify_cloud_browser(browser = :firefox)
    end

    it 'connects to an IE browser on LambdaTest' do
      ENV['BS_BROWSER'] = 'Internet Explorer'
      ENV['BS_OS'] = 'Windows 10'
      WebDriverConnect.initialize_web_driver
      verify_cloud_browser(browser = :internet_explorer)
    end
  end

  after(:each) do
    WebDriverConnect.close_all_drivers
  end

  def verify_cloud_browser(browser)
    # load Apple web site
    Capybara.page.driver.browser.navigate.to(test_site_url)
    Capybara.page.find(:css, test_site_locator, wait: 10, visible: true)

    # verify Environs are correctly set
    expect(Environ.browser).to eq(browser)
    expect(Environ.platform).to eq(:desktop)
    expect(Environ.session_state).to eq(:running)
    expect(Environ.driver).to eq(:lambdatest)
    expect(Environ.grid).to eq(:lambdatest)
    expect(Environ.os).to eq(ENV['TB_OS'])
    expect(Environ.device).to eq(:web)
    expect(Environ.is_web?).to eq(true)
    expect(Environ.is_device?).to eq(false)
    expect(Capybara.current_driver).to eq("lambdatest_#{browser}".downcase.to_sym)
  end
end
