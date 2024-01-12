# frozen_string_literal: true

RSpec.describe TestCentricity::WebDriverConnect, required: true do
  include_context 'test_site'

  context 'Connect to locally hosted desktop web browsers using W3C desired_capabilities hash' do
    context 'local web browser instances' do
      it 'num_drivers returns 0 when no WebDrivers have been instantiated' do
        expect(WebDriverConnect.num_drivers).to eq(0)
      end

      it 'raises exception when no capabilities defined' do
        caps = {
          capabilities: { browserName: :firefox },
          driver: :invalid_driver
        }
        expect { WebDriverConnect.initialize_web_driver(caps) }.to raise_error('invalid_driver is not a supported driver')
      end

      it 'raises exception when no :browserName is specified' do
        caps = {
          capabilities: { orientation: :portrait },
          driver: :webdriver
        }
        expect { WebDriverConnect.initialize_web_driver(caps) }.to raise_error('Missing :browserName in @capabilities')
      end

      it 'connects to a local Firefox browser' do
        caps = {
          capabilities: { browserName: :firefox },
          driver: :webdriver
        }
        WebDriverConnect.initialize_web_driver(caps)
        verify_local_browser(browser = :firefox, platform = :desktop, headless = false)
        expect(WebDriverConnect.num_drivers).to eq(1)
      end

      it 'connects to a local Safari browser' do
        caps = {
          capabilities: { browserName: :safari },
          driver: :webdriver
        }
        WebDriverConnect.initialize_web_driver(caps)
        verify_local_browser(browser = :safari, platform = :desktop, headless = false)
      end

      it 'connects to a local Chrome browser' do
        caps = {
          capabilities: { browserName: :chrome },
          driver: :webdriver,
          browser_size: 'max'
        }
        WebDriverConnect.initialize_web_driver(caps)
        verify_local_browser(browser = :chrome, platform = :desktop, headless = false)
      end

      it 'connects to a local Edge browser' do
        caps = {
          capabilities: { browserName: :edge },
          browser_size: [1100, 900],
          driver: :webdriver
        }
        WebDriverConnect.initialize_web_driver(caps)
        verify_local_browser(browser = :edge, platform = :desktop, headless = false)
        expect(Environ.browser_size).to eq([1100, 900])
      end

      it 'connects to a local emulated mobile web browser with default orientation' do
        caps = {
          capabilities: { browserName: :ipad_pro_12_9 },
          driver: :webdriver
        }
        WebDriverConnect.initialize_web_driver(caps)
        verify_local_browser(browser = :ipad_pro_12_9, platform = :mobile, headless = false)
        expect(Environ.device_orientation).to eq(:landscape)
        expect(Environ.browser_size).to eq([1366, 1024])
      end

      it 'connects to a user defined local emulated mobile web browser with default orientation' do
        caps = {
          capabilities: { browserName: :ipad_mini_os16 },
          driver: :webdriver
        }
        WebDriverConnect.initialize_web_driver(caps)
        verify_local_browser(browser = :ipad_mini_os16, platform = :mobile, headless = false)
        expect(Environ.device_orientation).to eq(:landscape)
        expect(Environ.browser_size).to eq([1133, 744])
      end

      it 'connects to a local emulated mobile web browser with portrait orientation' do
        caps = {
          capabilities: {
            browserName: :ipad_pro_12_9,
            orientation: :portrait
          },
          driver: :webdriver
        }
        WebDriverConnect.initialize_web_driver(caps)
        verify_local_browser(browser = :ipad_pro_12_9, platform = :mobile, headless = false)
        expect(Environ.device_orientation).to eq(:portrait)
        expect(Environ.browser_size).to eq([1024, 1366])
      end

      it 'connects to a local Firefox browser with a user-defined driver name' do
        caps = {
          browser_size: [1100, 900],
          capabilities: { browserName: :firefox },
          driver: :webdriver,
          driver_name: :my_custom_firefox_driver
        }
        WebDriverConnect.initialize_web_driver(caps)
        verify_local_browser(browser = :firefox, platform = :desktop, headless = false, driver_name = :my_custom_firefox_driver)
      end
    end

    context 'local headless browser instances' do
      it 'connects to a local headless Chrome browser' do
        caps = {
          capabilities: { browserName: :chrome_headless },
          driver: :webdriver
        }
        WebDriverConnect.initialize_web_driver(caps)
        verify_local_browser(browser = :chrome_headless, platform = :desktop, headless = true)
      end

      it 'connects to a local headless Edge browser' do
        caps = {
          capabilities: { browserName: :edge_headless },
          driver: :webdriver
        }
        WebDriverConnect.initialize_web_driver(caps)
        verify_local_browser(browser = :edge_headless, platform = :desktop, headless = true)
      end

      it 'connects to a local headless Firefox browser' do
        caps = {
          capabilities: { browserName: :firefox_headless },
          driver: :webdriver
        }
        WebDriverConnect.initialize_web_driver(caps)
        verify_local_browser(browser = :firefox_headless, platform = :desktop, headless = true)
      end
    end
  end

  context 'Connect to locally hosted desktop web browsers using environment variables' do
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
        ENV['BROWSER_SIZE'] = 'max'
        WebDriverConnect.initialize_web_driver
        Browsers.suppress_js_leave_page_modal
        verify_local_browser(browser = :chrome, platform = :desktop, headless = false)
      end

      it 'connects to a local Edge browser' do
        ENV['WEB_BROWSER'] = 'edge'
        ENV['BROWSER_SIZE'] = '1300, 1000'
        WebDriverConnect.initialize_web_driver
        Browsers.suppress_js_alerts
        verify_local_browser(browser = :edge, platform = :desktop, headless = false)
        expect(Environ.browser_size).to eq([1300, 1000])
      end

      it 'connects to a local emulated mobile web browser' do
        ENV['WEB_BROWSER'] = 'ipad_pro_12_9'
        ENV['ORIENTATION'] = 'portrait'
        WebDriverConnect.initialize_web_driver
        Browsers.set_device_orientation(:landscape)
        verify_local_browser(browser = :ipad_pro_12_9, platform = :mobile, headless = false)
        expect(Environ.device_orientation).to eq(:landscape)
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
  end

  after(:each) do
    WebDriverConnect.close_all_drivers
  end

  def verify_local_browser(browser, platform, headless, driver_name = nil)
    # load Apple web site
    Capybara.page.driver.browser.navigate.to(test_site_url)
    Capybara.page.find(:css, test_site_locator, wait: 10, visible: true)
    # verify Environs are correctly set
    expect(Environ.browser).to eq(browser)
    expect(Environ.platform).to eq(platform)
    expect(Environ.headless).to eq(headless)
    expect(Environ.session_state).to eq(:running)
    expect(Environ.driver).to eq(:webdriver)
    expect(Environ.device).to eq(:web)
    expect(Environ.is_web?).to eq(true)
    expect(Environ.grid).to eq(nil)
    driver_name = "local_#{Environ.browser}".downcase.to_sym if driver_name.nil?
    expect(Capybara.current_driver).to eq(driver_name)
  end
end
