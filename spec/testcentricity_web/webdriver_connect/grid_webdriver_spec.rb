# frozen_string_literal: true

RSpec.describe TestCentricity::WebDriverConnect, grid: true do
  include_context 'test_site'

  before(:context) do
    ENV['DRIVER'] = 'grid'
    ENV['DOWNLOADS'] = 'true'
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
          capabilities: { browserName: :firefox },
          driver: :grid,
          endpoint: 'http://localhost:4444/wd/hub'
        }
        WebDriverConnect.initialize_web_driver(caps)
        verify_grid_browser(browser = :firefox, platform = :desktop, headless = false)
      end

      it 'connects to a grid hosted Chrome browser' do
        caps = {
          capabilities: { browserName: :chrome },
          driver: :grid,
          endpoint: 'http://localhost:4444/wd/hub',
          browser_size: 'max'
        }
        WebDriverConnect.initialize_web_driver(caps)
        verify_grid_browser(browser = :chrome, platform = :desktop, headless = false)
      end

      it 'connects to a grid hosted Edge browser' do
        caps = {
          capabilities: { browserName: :edge },
          driver: :grid,
          endpoint: 'http://localhost:4444/wd/hub',
          browser_size: [1100, 900]
        }
        WebDriverConnect.initialize_web_driver(caps)
        verify_grid_browser(browser = :edge, platform = :desktop, headless = false)
        expect(Environ.browser_size).to eq([1100, 900])
      end

      it 'connects to a grid hosted emulated mobile web browser' do
        caps = {
          capabilities: { browserName: :ipad_pro_12_9 },
          driver: :grid
        }
        WebDriverConnect.initialize_web_driver(caps)
        verify_grid_browser(browser = :ipad_pro_12_9, platform = :mobile, headless = false)
        expect(Environ.device_orientation).to eq(:landscape)
        expect(Environ.browser_size).to eq([1366, 1024])
      end

      it 'connects to a user defined grid hosted emulated mobile web browser with default orientation' do
        caps = {
          capabilities: { browserName: :ipad_mini_os16 },
          driver: :grid
        }
        WebDriverConnect.initialize_web_driver(caps)
        verify_grid_browser(browser = :ipad_mini_os16, platform = :mobile, headless = false)
        expect(Environ.device_orientation).to eq(:landscape)
        expect(Environ.browser_size).to eq([1133, 744])
      end

      it 'connects to a grid hosted Chrome browser with a user-defined driver name' do
        caps = {
          browser_size: [1100, 900],
          capabilities: { browserName: :chrome },
          driver: :grid,
          driver_name: :my_custom_chrome_driver,
          endpoint: 'http://localhost:4444/wd/hub'
        }
        WebDriverConnect.initialize_web_driver(caps)
        verify_grid_browser(browser = :chrome, platform = :desktop, headless = false, driver_name = :my_custom_chrome_driver)
      end

      it 'connects to a grid hosted Firefox browser with a user-defined driver name' do
        caps = {
          capabilities: { browserName: :firefox },
          driver: :grid,
          driver_name: :my_custom_firefox_driver
        }
        WebDriverConnect.initialize_web_driver(caps)
        verify_grid_browser(browser = :firefox, platform = :desktop, headless = false, driver_name = :my_custom_firefox_driver)
      end
    end

    context 'grid headless browser instances' do
      it 'connects to a grid hosted headless Chrome browser' do
        caps = {
          capabilities: { browserName: :chrome_headless },
          driver: :grid
        }
        WebDriverConnect.initialize_web_driver(caps)
        verify_grid_browser(browser = :chrome_headless, platform = :desktop, headless = true)
      end

      it 'connects to a grid hosted headless Edge browser' do
        caps = {
          capabilities: { browserName: :edge_headless },
          driver: :grid
        }
        WebDriverConnect.initialize_web_driver(caps)
        verify_grid_browser(browser = :edge_headless, platform = :desktop, headless = true)
      end

      it 'connects to a grid hosted headless Firefox browser' do
        caps = {
          capabilities: { browserName: :firefox_headless },
          driver: :grid
        }
        WebDriverConnect.initialize_web_driver(caps)
        verify_grid_browser(browser = :firefox_headless, platform = :desktop, headless = true)
      end
    end

    context 'Connect to multiple grid hosted web browsers' do
      it 'connects to multiple desktop and emulated mobile browsers' do
        # instantiate a grid hosted emulated iPad browser
        caps = {
          capabilities: { browserName: :ipad_pro_12_9 },
          driver_name: :emulated_ipad,
          driver: :grid
        }
        WebDriverConnect.initialize_web_driver(caps)

        # instantiate a grid hosted desktop Firefox browser
        caps = {
          capabilities: { browserName: :firefox },
          browser_size: [1100, 900],
          driver: :grid
        }
        WebDriverConnect.initialize_web_driver(caps)

        # instantiate a grid hosted desktop Edge browser
        caps = {
          capabilities: { browserName: :edge },
          browser_size: [1000, 800],
          driver: :grid
        }
        WebDriverConnect.initialize_web_driver(caps)

        # instantiate a grid hosted emulated iPhone browser
        caps = {
          capabilities: { browserName: :iphone_11_pro_max },
          driver_name: :emulated_iphone,
          driver: :grid
        }
        WebDriverConnect.initialize_web_driver(caps)

        # verify that 4 driver instances have been initialized
        expect(WebDriverConnect.num_drivers).to eq(4)

        # activate and verify the grid Firefox desktop browser instance
        WebDriverConnect.activate_driver(:remote_firefox)
        verify_grid_browser(browser = :firefox, platform = :desktop, headless = false)

        # activate and verify the grid emulated iPhone browser instance
        WebDriverConnect.activate_driver(:emulated_iphone)
        verify_grid_browser(browser = :iphone_11_pro_max, platform = :mobile, headless = false, driver_name = :emulated_iphone)
        expect(Environ.device_orientation).to eq(:portrait)
        expect(Environ.browser_size).to eq([414, 896])

        # activate and verify the grid emulated iPad browser instance
        WebDriverConnect.activate_driver(:emulated_ipad)
        verify_grid_browser(browser = :ipad_pro_12_9, platform = :mobile, headless = false, driver_name = :emulated_ipad)
        expect(Environ.device_orientation).to eq(:landscape)
        expect(Environ.browser_size).to eq([1366, 1024])

        # activate and verify the grid Edge desktop browser instance
        WebDriverConnect.activate_driver(:remote_edge)
        verify_grid_browser(browser = :edge, platform = :desktop, headless = false)
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
    WebDriverConnect.close_all_drivers
    # verify that all driver instances have been closed
    expect(WebDriverConnect.num_drivers).to eq(0)
    # remove Downloads folder if one was created
    Dir.delete(WebDriverConnect.downloads_path) if Dir.exist?(WebDriverConnect.downloads_path)
  end

  def verify_grid_browser(browser, platform, headless, driver_name = nil)
    # load Apple web site
    Capybara.page.driver.browser.navigate.to(test_site_url)
    Capybara.page.find(:css, test_site_locator, wait: 10, visible: true)
    # verify Environs are correctly set
    expect(Environ.browser).to eq(browser)
    expect(Environ.platform).to eq(platform)
    expect(Environ.headless).to eq(headless)
    expect(Environ.session_state).to eq(:running)
    expect(Environ.driver).to eq(:grid)
    expect(Environ.device).to eq(:web)
    expect(Environ.grid).to eq(:selenium_grid)
    driver_name = "remote_#{Environ.browser}".downcase.to_sym if driver_name.nil?
    expect(Capybara.current_driver).to eq(driver_name)
    expect(Dir.exist?(WebDriverConnect.downloads_path)).to eq(true)
  end
end
