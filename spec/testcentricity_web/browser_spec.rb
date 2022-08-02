# frozen_string_literal: true

RSpec.describe TestCentricity::Browsers, required: true do
  before(:context) do
    # instantiate local test environment
    @environs ||= EnvironData
    @environs.find_environ('LOCAL', :yaml)
    ENV['WEB_BROWSER'] = 'chrome_headless'
  end

  context 'web browser with multiple tabs/windows' do
    it 'returns number of browser windows/tabs' do
      WebDriverConnect.initialize_web_driver
      Capybara.current_session.open_new_window
      Capybara.current_session.open_new_window
      expect(Browsers.num_browser_instances).to eql 3
    end

    it 'closes original browser instance' do
      WebDriverConnect.initialize_web_driver
      Capybara.current_session.open_new_window
      Browsers.close_old_browser_instance
      expect(Browsers.num_browser_instances).to eql 1
    end

    it 'closes current browser instance' do
      WebDriverConnect.initialize_web_driver
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
