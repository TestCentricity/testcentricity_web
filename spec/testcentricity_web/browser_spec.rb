# frozen_string_literal: true

RSpec.describe TestCentricity::Browsers, required: true do
  before(:each) do
    ENV['WEB_BROWSER'] = 'chrome'
    WebDriverConnect.initialize_web_driver
    # load Apple web site
    Capybara.page.driver.browser.navigate.to('https://www.apple.com')
    Capybara.page.find(:css, 'nav#ac-globalnav', wait: 10, visible: true)
  end

  context 'web browser with multiple tabs/windows' do
    it 'returns number of browser windows/tabs' do
      Browsers.scroll_to_bottom
      sleep(2)
      Capybara.current_session.open_new_window
      Capybara.current_session.open_new_window
      expect(Browsers.num_browser_instances).to eql 3
    end

    it 'closes original browser instance' do
      Browsers.scroll_to(200, 400)
      sleep(2)
      Capybara.current_session.open_new_window
      Browsers.close_old_browser_instance
      expect(Browsers.num_browser_instances).to eql 1
    end

    it 'closes current browser instance' do
      Browsers.scroll_to_top
      Capybara.current_session.open_new_window
      Browsers.switch_to_new_browser_instance
      Capybara.current_session.open_new_window
      Browsers.close_current_browser_instance
      expect(Browsers.num_browser_instances).to eql 2
    end
  end

  after(:each) do
    Browsers.close_all_browser_instances
    Capybara.current_session.quit
    Environ.session_state = :quit
  end
end
