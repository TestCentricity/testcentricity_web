module TestCentricity
  class Browsers
    include Capybara::DSL

    # Resize selenium browser window to avoid Selenium::WebDriver::Error::MoveTargetOutOfBoundsError errors
    #
    # Example usage:
    #
    #   config.before(:each) do
    #     set_browser_window_size(1250, 800) if Capybara.current_driver == :selenium
    #   end
    #
    def self.set_browser_window_size(resolution)
      window = Capybara.current_session.driver.browser.manage.window
      window.resize_to(resolution[0], resolution[1])
    end

    def self.maximize_browser
      window = Capybara.current_session.driver.browser.manage.window
      window.maximize
    end

    def self.refresh_browser
      page.driver.browser.navigate.refresh
    end

    def self.switch_to_new_browser_instance
      page.driver.browser.switch_to.window(page.driver.browser.window_handles.last)
    end

    def self.close_all_browser_instances
      page.driver.browser.window_handles.each do |handle|
        page.driver.browser.switch_to.window(handle)
        page.driver.browser.close
      end
    end

    def self.close_current_browser_window
      page.driver.browser.close
      page.driver.browser.switch_to.window(page.driver.browser.window_handles.last)
    end

    def self.close_old_browser_instance
      page.driver.browser.switch_to.window(page.driver.browser.window_handles.first)
      page.driver.browser.close
      page.driver.browser.switch_to.window(page.driver.browser.window_handles.last)
    end

    def self.close_named_browser_instance(name)
      page.driver.browser.switch_to.window(page.driver.find_window(name))
      page.driver.browser.close
      page.driver.browser.switch_to.window(page.driver.browser.window_handles.last)
    end

    def self.delete_all_cookies
      if Capybara.current_driver == :selenium
        browser = Capybara.current_session.driver.browser
        if browser.respond_to?(:manage) and browser.manage.respond_to?(:delete_all_cookies)
          browser.manage.delete_all_cookies
        else
          raise 'Could not clear cookies.'
        end
      end
    end

    def self.mobile_device_agent(device)
      key = device.gsub(/\s+/, "").downcase.to_sym
      devices = device_agents
      agent_string = devices[key]
      raise "Device '#{device}' is not defined" unless agent_string
      agent_string
    end

    def self.browser_size(browser, orientation)
      key = browser.gsub(/\s+/, "").downcase.to_sym
      sizes = device_sizes
      browser_data = sizes[key]
      if browser_data
        width = browser_data[0]
        height = browser_data[1]
        default_orientation = browser_data[2]
        if orientation
          (orientation.downcase.to_sym == default_orientation) ?
              size = [width, height] :
              size = [height, width]
        else
          size = [width, height]
        end
      else
        size = [1900, 1000]
      end
      size
    end

    private

    def self.device_agents
      devices = { :iphone           => "Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1",
                  :iphone4          => "Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1",
                  :iphone5          => "Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1",
                  :iphone6          => "Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1",
                  :iphone6_plus     => "Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1",
                  :ipad             => "Mozilla/5.0 (iPad; CPU OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/3B143 Safari/601.1",
                  :ipad_pro         => "Mozilla/5.0 (iPad; CPU OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B137 Safari/601.1",
                  :android_phone    => "Mozilla/5.0 (Linux; U; Android 4.0.1; en-us; sdk Build/ICS_MR0) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30",
                  :android_tablet   => "Mozilla/5.0 (Linux; U; Android 3.0; en-us; GT-P7100 Build/HRI83) AppleWebkit/534.13 (KHTML, like Gecko) Version/4.0 Safari/534.13",
                  :windows_phone8   => "Mozilla/5.0 (compatible; MSIE 10.0; Windows Phone 8.0; Trident/6.0; IEMobile/10.0; ARM; Touch; NOKIA; Lumia 920)",
                  :windows_phone7   => "Mozilla/5.0 (compatible; MSIE 9.0; Windows Phone OS 7.5; Trident/5.0; IEMobile/9.0; NOKIA; Lumia 710)"
      }
      devices
    end

    def self.device_sizes
      sizes = { :iphone           => [320,  568,  :portrait],
                :iphone4          => [320,  480,  :portrait],
                :iphone5          => [320,  568,  :portrait],
                :iphone6          => [375,  667,  :portrait],
                :iphone6_plus     => [414,  736,  :portrait],
                :ipad             => [1024, 768,  :landscape],
                :ipad_pro         => [1366, 1024, :landscape],
                :android_phone    => [320,  480,  :portrait],
                :android_tablet   => [1024, 768,  :landscape],
                :windows_phone8   => [320,  480,  :portrait],
                :windows_phone7   => [320,  480,  :portrait]
      }
      sizes
    end
  end
end
