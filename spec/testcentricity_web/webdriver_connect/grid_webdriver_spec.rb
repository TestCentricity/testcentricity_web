# frozen_string_literal: true

RSpec.describe TestCentricity::WebDriverConnect, grid: true do
  before(:context) do
    ENV['SELENIUM'] = 'remote'
    endpoint = 'http://localhost:4444/wd/hub'
    ENV['REMOTE_ENDPOINT'] = endpoint
    # wait for Dockerized Selenium grid to be running
    20.downto(0) do |interval|
      begin
        response = HTTParty.get("#{endpoint}/status")
        break if response.body.include?('Selenium Grid ready')
      rescue
        if interval == 0
          raise 'Selenium Grid is not running.'
        else
          sleep(1)
        end
      end
    end
  end

  context 'Connect to Selenium Grid hosted desktop web browsers using W3C desired_capabilities hash' do
    context 'grid web browser instances' do
      it 'connects to a grid hosted Firefox browser' do
        caps = {
          desired_capabilities: { browserName: :firefox },
          driver: :webdriver
        }
        WebDriverConnect.initialize_web_driver(caps)
        verify_grid_browser(browser = :firefox, platform = :desktop, headless = false)
      end

      it 'connects to a grid hosted Chrome browser' do
        caps = {
          desired_capabilities: {
            browserName: :chrome,
            browser_size: 'max'
          },
          driver: :webdriver
        }
        WebDriverConnect.initialize_web_driver(caps)
        verify_grid_browser(browser = :chrome, platform = :desktop, headless = false)
      end

      it 'connects to a grid hosted Edge browser' do
        caps = {
          desired_capabilities: {
            browserName: :edge,
            browser_size: [1100, 900]
          },
          driver: :webdriver
        }
        WebDriverConnect.initialize_web_driver(caps)
        verify_grid_browser(browser = :edge, platform = :desktop, headless = false)
        expect(Environ.browser_size).to eq([1100, 900])
      end

      it 'connects to a grid hosted emulated mobile web browser' do
        caps = {
          desired_capabilities: { browserName: :ipad_pro_12_9 },
          driver: :webdriver
        }
        WebDriverConnect.initialize_web_driver(caps)
        verify_grid_browser(browser = :ipad_pro_12_9, platform = :mobile, headless = false)
        expect(Environ.browser_size).to eq([1366, 1024])
      end

      it 'connects to a grid hosted Chrome browser with a user-defined driver name (String)' do
        caps = {
          desired_capabilities: { browserName: :chrome },
          driver: :webdriver,
          driver_name: 'my_custom_chrome_driver'
        }
        WebDriverConnect.initialize_web_driver(caps)
        verify_grid_browser(browser = :chrome, platform = :desktop, headless = false, driver_name = :my_custom_chrome_driver)
      end

      it 'connects to a grid hosted Firefox browser with a user-defined driver name (Symbol)' do
        caps = {
          desired_capabilities: { browserName: :firefox },
          driver: :webdriver,
          driver_name: :my_custom_firefox_driver
        }
        WebDriverConnect.initialize_web_driver(caps)
        verify_grid_browser(browser = :firefox, platform = :desktop, headless = false, driver_name = :my_custom_firefox_driver)
      end
    end

    context 'grid headless browser instances' do
      it 'connects to a grid hosted headless Chrome browser' do
        caps = {
          desired_capabilities: { browserName: :chrome_headless },
          driver: :webdriver
        }
        WebDriverConnect.initialize_web_driver(caps)
        verify_grid_browser(browser = :chrome_headless, platform = :desktop, headless = true)
      end

      it 'connects to a grid hosted headless Edge browser' do
        caps = {
          desired_capabilities: { browserName: :edge_headless },
          driver: :webdriver
        }
        WebDriverConnect.initialize_web_driver(caps)
        verify_grid_browser(browser = :edge_headless, platform = :desktop, headless = true)
      end

      it 'connects to a grid hosted headless Firefox browser' do
        caps = {
          desired_capabilities: { browserName: :firefox_headless },
          driver: :webdriver
        }
        WebDriverConnect.initialize_web_driver(caps)
        verify_grid_browser(browser = :firefox_headless, platform = :desktop, headless = true)
      end
    end
  end

  context 'Connect to Selenium Grid hosted desktop web browsers using environment variables' do
    context 'grid web browser instances' do
      it 'connects to a grid hosted Firefox browser' do
        ENV['WEB_BROWSER'] = 'firefox'
        WebDriverConnect.initialize_web_driver
        verify_grid_browser(browser = :firefox, platform = :desktop, headless = false)
      end

      it 'connects to a grid hosted Chrome browser' do
        ENV['WEB_BROWSER'] = 'chrome'
        ENV['BROWSER_SIZE'] = 'max'
        WebDriverConnect.initialize_web_driver
        Browsers.suppress_js_leave_page_modal
        verify_grid_browser(browser = :chrome, platform = :desktop, headless = false)
      end

      it 'connects to a grid hosted Edge browser' do
        ENV['WEB_BROWSER'] = 'edge'
        ENV['BROWSER_SIZE'] = '1300, 1000'
        WebDriverConnect.initialize_web_driver
        Browsers.suppress_js_alerts
        verify_grid_browser(browser = :edge, platform = :desktop, headless = false)
        expect(Environ.browser_size).to eq([1300, 1000])
      end

      it 'connects to a grid hosted emulated mobile web browser' do
        ENV['WEB_BROWSER'] = 'ipad_pro_12_9'
        ENV['ORIENTATION'] = 'portrait'
        WebDriverConnect.initialize_web_driver
        Browsers.set_device_orientation('landscape')
        verify_grid_browser(browser = :ipad_pro_12_9, platform = :mobile, headless = false)
        expect(Environ.device_orientation).to eq(:landscape)
      end
    end

    context 'grid headless browser instances' do
      it 'connects to a grid hosted headless Chrome browser' do
        ENV['WEB_BROWSER'] = 'chrome_headless'
        WebDriverConnect.initialize_web_driver
        Browsers.maximize_browser
        verify_grid_browser(browser = :chrome_headless, platform = :desktop, headless = true)
      end

      it 'connects to a grid hosted headless Edge browser' do
        ENV['WEB_BROWSER'] = 'edge_headless'
        WebDriverConnect.initialize_web_driver
        Browsers.refresh_browser
        verify_grid_browser(browser = :edge_headless, platform = :desktop, headless = true)
      end

      it 'connects to a grid hosted headless Firefox browser' do
        ENV['WEB_BROWSER'] = 'firefox_headless'
        WebDriverConnect.initialize_web_driver
        Browsers.delete_all_cookies
        verify_grid_browser(browser = :firefox_headless, platform = :desktop, headless = true)
      end
    end
  end

  after(:each) do
    Capybara.current_session.quit
    Environ.session_state = :quit
  end

  def verify_grid_browser(browser, platform, headless, driver_name = nil)
    # load Apple web site
    Capybara.page.driver.browser.navigate.to('https://www.apple.com')
    Capybara.page.find(:css, 'nav#ac-globalnav', wait: 10, visible: true)
    # verify Environs are correctly set
    expect(Environ.browser).to eq(browser)
    expect(Environ.platform).to eq(platform)
    expect(Environ.headless).to eq(headless)
    expect(Environ.session_state).to eq(:running)
    expect(Environ.driver).to eq(:webdriver)
    expect(Environ.device).to eq(:web)
    expect(Environ.grid).to eq(:selenium_grid)
    driver_name = "remote_#{Environ.browser}".downcase.to_sym if driver_name.nil?
    expect(Capybara.current_driver).to eq(driver_name)
  end
end
