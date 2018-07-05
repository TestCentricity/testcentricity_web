require 'yaml'


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
      Environ.browser_size = [resolution[0].to_i, resolution[1].to_i]
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
    # Sets the position of the browser window.
    #
    # @param x [Integer] the desired x coordinate
    # @param y [Integer] the desired y coordinate
    # @example
    #   Browsers.set_browser_window_position([100, 300])
    #
    def self.set_browser_window_position(x, y)
      window = Capybara.current_session.driver.browser.manage.window
      window.move_to(x, y)
    end

    # Refreshes the selenium browser.
    #
    # @example
    #   Browsers.refresh_browser
    #
    def self.refresh_browser
      Capybara.page.driver.browser.navigate.refresh
    end

    # Emulates clicking the web browser's Back button. Navigates back by one page on the browser’s history.
    #
    # @example
    #   Browsers.navigate_back
    #
    def self.navigate_back
      Capybara.page.driver.browser.navigate.back
    end

    # Emulates clicking the web browser's Forward button. Navigates forward by one page on the browser’s history.
    #
    # @example
    #   Browsers.navigate_forward
    #
    def self.navigate_forward
      Capybara.page.driver.browser.navigate.forward
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

    def self.num_browser_instances
      Capybara.page.driver.browser.window_handles.count
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

    def self.suppress_js_alerts
      Capybara.page.execute_script('window.alert = function() {}')
    end

    def self.suppress_js_leave_page_modal
      Capybara.page.execute_script('window.onbeforeunload = null')
    end

    def self.delete_all_cookies
      if Capybara.current_driver == :selenium
        browser = Capybara.current_session.driver.browser
        if browser.respond_to?(:manage) && browser.manage.respond_to?(:delete_all_cookies)
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
      device_name = device.gsub(/\s+/, '').downcase.to_sym
      device = get_devices[device_name]
      agent_string = device[:user_agent]
      raise "Device '#{device}' is not defined" unless agent_string
      agent_string
    end

    def self.mobile_device_name(device)
      device_name = device.gsub(/\s+/, '').downcase.to_sym
      device = get_devices[device_name]
      name = device[:name]
      raise "Device '#{device}' is not defined" unless name
      Environ.device_os = device[:os]
      Environ.device_type = device[:type]
      name
    end

    def self.browser_size(browser, orientation)
      device_name = browser.gsub(/\s+/, '').downcase.to_sym
      device = get_devices[device_name]
      if device
        width = device[:css_width]
        height = device[:css_height]
        default_orientation = device[:default_orientation].to_sym
        if orientation
          Environ.device_orientation = orientation
          size = if orientation.downcase.to_sym == default_orientation
                   [width, height]
                 else
                   [height, width]
                 end
        else
          Environ.device_orientation = device[:default_orientation]
          size = [width, height]
        end
      else
        size = [1650, 1000]
      end
      size
    end

    private

    def self.get_devices
      YAML.load_file File.expand_path('../../devices/devices.yml', __FILE__)
    end
  end
end
