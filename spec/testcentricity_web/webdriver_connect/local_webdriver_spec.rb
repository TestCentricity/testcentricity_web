# frozen_string_literal: true

describe TestCentricity::WebDriverConnect, required: true do
  before(:context) do
    # instantiate local test environment
    @environs ||= EnvironData
    @environs.find_environ('LOCAL', :yaml)
    ENV['SELENIUM'] = ''
  end

  context 'local web browser instances' do
    it 'connects to a local Firefox browser' do
      ENV['WEB_BROWSER'] = 'firefox'
      WebDriverConnect.initialize_web_driver
      verify_local_browser(browser = :firefox, platform = :desktop, headless = false)
    end

    it 'connects to a local Safari browser' do
      ENV['WEB_BROWSER'] = 'safari'
      WebDriverConnect.initialize_web_driver
      verify_local_browser(browser = :safari, platform = :desktop, headless = false)
    end

    it 'connects to a local Chrome browser' do
      ENV['WEB_BROWSER'] = 'chrome'
      WebDriverConnect.initialize_web_driver
      Browsers.suppress_js_leave_page_modal
      verify_local_browser(browser = :chrome, platform = :desktop, headless = false)
    end

    it 'connects to a local Edge browser' do
      ENV['WEB_BROWSER'] = 'edge'
      WebDriverConnect.initialize_web_driver
      Browsers.suppress_js_alerts
      verify_local_browser(browser = :edge, platform = :desktop, headless = false)
    end

    it 'connects to a local emulated mobile web browser' do
      ENV['WEB_BROWSER'] = 'ipad_pro_12_9'
      ENV['HOST_BROWSER'] = 'chrome'
      ENV['ORIENTATION'] = 'portrait'
      WebDriverConnect.initialize_web_driver
      Browsers.set_device_orientation('landscape')
      verify_local_browser(browser = :ipad_pro_12_9, platform = :mobile, headless = false)
      expect(Environ.browser_size).to eq([1366, 1024])
    end
  end

  context 'local headless browser instances' do
    it 'connects to a local headless Chrome browser' do
      ENV['WEB_BROWSER'] = 'chrome_headless'
      WebDriverConnect.initialize_web_driver
      Browsers.maximize_browser
      verify_local_browser(browser = :chrome_headless, platform = :desktop, headless = true)
    end

    it 'connects to a local headless Edge browser' do
      ENV['WEB_BROWSER'] = 'edge_headless'
      WebDriverConnect.initialize_web_driver
      Browsers.refresh_browser
      verify_local_browser(browser = :edge_headless, platform = :desktop, headless = true)
    end

    it 'connects to a local headless Firefox browser' do
      ENV['WEB_BROWSER'] = 'firefox_headless'
      WebDriverConnect.initialize_web_driver
      Browsers.delete_all_cookies
      verify_local_browser(browser = :firefox_headless, platform = :desktop, headless = true)
    end
  end

  after(:each) do
    Capybara.current_session.quit
    Environ.session_state = :quit
  end

  def verify_local_browser(browser, platform, headless)
    expect(Environ.browser).to eq(browser)
    expect(Environ.platform).to eq(platform)
    expect(Environ.headless).to eq(headless)
    expect(Environ.session_state).to eq(:running)
    expect(Environ.driver).to eq(:webdriver)
    expect(Environ.device).to eq(:web)
    expect(Environ.is_web?).to eq(true)
  end
end
