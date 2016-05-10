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
      device_name = device.gsub(/\s+/, "").downcase.to_sym
      device = get_devices[device_name]
      agent_string = device[:user_agent]
      raise "Device '#{device}' is not defined" unless agent_string
      agent_string
    end

    def self.browser_size(browser, orientation)
      device_name = browser.gsub(/\s+/, "").downcase.to_sym
      device = get_devices[device_name]
      if device
        width = device[:css_width]
        height = device[:css_height]
        default_orientation = device[:default_orientation].to_sym
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

    def self.get_devices
      YAML.load_file File.expand_path("../../devices/devices.yml", __FILE__)
    end
  end
end
