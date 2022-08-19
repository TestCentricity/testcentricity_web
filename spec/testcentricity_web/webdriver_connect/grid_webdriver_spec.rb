# frozen_string_literal: true

RSpec.describe TestCentricity::WebDriverConnect, grid: true do
  before(:context) do
    # instantiate remote test environment
    @environs ||= EnvironData
    @environs.find_environ('LOCAL', :yaml)
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

  context 'grid web browser instances' do
    it 'connects to a grid hosted Firefox browser' do
      ENV['WEB_BROWSER'] = 'firefox'
      WebDriverConnect.initialize_web_driver
      verify_grid_browser(browser = :firefox, platform = :desktop)
    end

    it 'connects to a grid hosted Chrome browser' do
      ENV['WEB_BROWSER'] = 'chrome'
      WebDriverConnect.initialize_web_driver
      Browsers.suppress_js_leave_page_modal
      verify_grid_browser(browser = :chrome, platform = :desktop)
    end

    it 'connects to a grid hosted Edge browser' do
      ENV['WEB_BROWSER'] = 'edge'
      WebDriverConnect.initialize_web_driver
      Browsers.suppress_js_alerts
      verify_grid_browser(browser = :edge, platform = :desktop)
    end

    it 'connects to a grid hosted emulated mobile web browser' do
      ENV['WEB_BROWSER'] = 'ipad_pro_12_9'
      ENV['HOST_BROWSER'] = 'chrome'
      ENV['ORIENTATION'] = 'portrait'
      WebDriverConnect.initialize_web_driver
      Browsers.set_device_orientation('landscape')
      verify_grid_browser(browser = :ipad_pro_12_9, platform = :mobile)
    end
  end

  after(:each) do
    $server.stop if Environ.driver == :appium && $server.running?
    Capybara.current_session.quit
    Environ.session_state = :quit
  end

  def verify_grid_browser(browser, platform)
    # load Apple web site
    Capybara.page.driver.browser.navigate.to('https://www.apple.com')
    Capybara.page.find(:css, 'nav#ac-globalnav', wait: 10, visible: true)
    # verify Environs are correctly set
    expect(Environ.browser).to eq(browser)
    expect(Environ.platform).to eq(platform)
    expect(Environ.headless).to eq(false)
    expect(Environ.session_state).to eq(:running)
    expect(Environ.driver).to eq(:webdriver)
    expect(Environ.device).to eq(:web)
    expect(Environ.grid).to eq(:selenium_grid)
  end
end
