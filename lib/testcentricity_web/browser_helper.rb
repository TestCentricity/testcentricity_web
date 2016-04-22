module TestCentricity
  module Browsers
    include Capybara::DSL

    # Sets the size of the browser window.
    #
    # @param resolution [Array] the desired [width, height]
    # @example
    #   Browsers.set_browser_window_size([1024, 768])
    #
    def self.set_browser_window_size(resolution)
      resolution = resolution.split(',') if resolution.is_a?(String)
      window = Capybara.current_session.driver.browser.manage.window
      window.resize_to(resolution[0], resolution[1])
    end

    # Maximizes the selenium browser window.
    #
    # @example
    #   Browsers.maximize_browser
    #
    def self.maximize_browser
      window = Capybara.current_session.driver.browser.manage.window
      window.maximize
    end

    # Refreshes the selenium browser.
    #
    # @example
    #   Browsers.refresh_browser
    #
    def self.refresh_browser
      Capybara.page.driver.browser.navigate.refresh
    end

    def self.switch_to_new_browser_instance
      Capybara.page.driver.browser.switch_to.window(Capybara.page.driver.browser.window_handles.last)
    end

    def self.close_all_browser_instances
      Capybara.page.driver.browser.window_handles.each do |handle|
        page.driver.browser.switch_to.window(handle)
        page.driver.browser.close
      end
    end

    def self.close_current_browser_instance
      Capybara.page.driver.browser.close
      Capybara.page.driver.browser.switch_to.window(Capybara.page.driver.browser.window_handles.last)
    end

    def self.close_old_browser_instance
      Capybara.page.driver.browser.switch_to.window(Capybara.page.driver.browser.window_handles.first)
      Capybara.page.driver.browser.close
      Capybara.page.driver.browser.switch_to.window(Capybara.page.driver.browser.window_handles.last)
    end

    def self.close_named_browser_instance(name)
      Capybara.page.driver.browser.switch_to.window(Capybara.page.driver.find_window(name))
      Capybara.page.driver.browser.close
      Capybara.page.driver.browser.switch_to.window(Capybara.page.driver.browser.window_handles.last)
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

    def self.set_device_orientation(orientation)
      if Environ.is_mobile? && !Environ.is_device?
        Browsers.set_browser_window_size(Browsers.browser_size(Environ.browser.to_s, orientation))
      else
        puts '***** Cannot change device orientation of desktop web browsers or remote devices *****'
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
        size = [1650, 1000]
      end
      size
    end

    private

    def self.device_agents
      devices = { :iphone              => "Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1",
                  :iphone4             => "Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1",
                  :iphone5             => "Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1",
                  :iphone6             => "Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1",
                  :iphone6_plus        => "Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1",
                  :ipad                => "Mozilla/5.0 (iPad; CPU OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/3B143 Safari/601.1",
                  :ipad_pro            => "Mozilla/5.0 (iPad; CPU OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B137 Safari/601.1",
                  :android_phone       => "Mozilla/5.0 (Linux; U; Android 4.0.1; en-us; sdk Build/ICS_MR0) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30",
                  :android_tablet      => "Mozilla/5.0 (Linux; U; Android 3.0; en-us; GT-P7100 Build/HRI83) AppleWebkit/534.13 (KHTML, like Gecko) Version/4.0 Safari/534.13",
                  :kindle_fire         => "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_3; en-us; Silk/1.0.141.16-Gen4_11004310) AppleWebkit/533.16 (KHTML, like Gecko) Version/5.0 Safari/533.16 Silk-Accelerated=true",
                  :kindle_firehd7      => "Mozilla/5.0 (Linux; U; en-us; KFTHWI Build/JDQ39) AppleWebKit/535.19 (KHTML, like Gecko) Silk/3.13 Safari/535.19 Silk-Accelerated=true",
                  :kindle_firehd8      => "Mozilla/5.0 (Linux; U; en-us; KFAPWI Build/JDQ39) AppleWebKit/535.19 (KHTML, like Gecko) Silk/3.13 Safari/535.19 Silk-Accelerated=true",
                  :windows_phone10     => "Mozilla/5.0 (Windows Phone 10.0; Android 4.2.1; DEVICE INFO) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.71 Mobile Safari/537.36 Edge/12.0",
                  :windows_phone8      => "Mozilla/5.0 (compatible; MSIE 10.0; Windows Phone 8.0; Trident/6.0; IEMobile/10.0; ARM; Touch; NOKIA; Lumia 920)",
                  :windows_phone7      => "Mozilla/5.0 (compatible; MSIE 9.0; Windows Phone OS 7.5; Trident/5.0; IEMobile/9.0; NOKIA; Lumia 710)",
                  :surface             => "Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.2; ARM; Trident/6.0; Touch)",
                  :blackberry_playbook => "Mozilla/5.0 (PlayBook; U; RIM Tablet OS 2.1.0; en-US) AppleWebKit/536.2+ (KHTML like Gecko) Version/7.2.1.0 Safari/536.2+"
      }
      devices
    end

    def self.device_sizes
      sizes = { :iphone              => [320,  480,  :portrait],
                :iphone4             => [320,  480,  :portrait],
                :iphone5             => [320,  568,  :portrait],
                :iphone6             => [375,  667,  :portrait],
                :iphone6_plus        => [414,  736,  :portrait],
                :android_phone       => [320,  480,  :portrait],
                :windows_phone8      => [320,  480,  :portrait],
                :windows_phone7      => [320,  480,  :portrait],
                :ipad                => [1024, 768,  :landscape],
                :ipad_pro            => [1366, 1024, :landscape],
                :android_tablet      => [1024, 768,  :landscape],
                :kindle_fire         => [1024, 600,  :landscape],
                :kindle_firehd7      => [800,  480,  :landscape],
                :kindle_firehd8      => [1280, 800,  :landscape],
                :surface             => [1366, 768,  :landscape],
                :blackberry_playbook => [1024, 600,  :landscape]
      }
      sizes
    end
  end
end
