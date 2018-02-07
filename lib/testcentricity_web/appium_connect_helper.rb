require 'appium_lib'


module TestCentricity
  module AppiumConnect

    attr_accessor :running

    def self.initialize_appium(project_path = nil)
      Environ.platform    = :mobile
      Environ.driver      = :appium
      Environ.device_type = ENV['DEVICE_TYPE'] if ENV['DEVICE_TYPE']

      if project_path.nil?
        Environ.device_name = ENV['APP_DEVICE']
        Environ.device_os   = ENV['APP_PLATFORM_NAME']
        Environ.device_orientation = ENV['ORIENTATION'] if ENV['ORIENTATION']
        desired_capabilities = {
            caps: {
                platformName:    ENV['APP_PLATFORM_NAME'],
                platformVersion: ENV['APP_VERSION'],
                deviceName:      ENV['APP_DEVICE'],
                automationName:  ENV['AUTOMATION_ENGINE']
            }
        }
        capabilities = desired_capabilities[:caps]
        capabilities[:avd] = ENV['APP_DEVICE'] if ENV['APP_PLATFORM_NAME'].downcase.to_sym == :android
        capabilities[:orientation] = ENV['ORIENTATION'].upcase if ENV['ORIENTATION']
        capabilities[:language] = ENV['LANGUAGE'] if ENV['LANGUAGE']
        capabilities[:locale] = ENV['LOCALE'].gsub('-', '_') if ENV['LOCALE']
        capabilities[:newCommandTimeout] = ENV['NEW_COMMAND_TIMEOUT'] if ENV['NEW_COMMAND_TIMEOUT']
        capabilities[:noReset] = ENV['APP_NO_RESET'] if ENV['APP_NO_RESET']
        capabilities[:fullReset] = ENV['APP_FULL_RESET'] if ENV['APP_FULL_RESET']
        if ENV['UDID']
          Environ.device = :device
          capabilities[:udid] = ENV['UDID']
          capabilities[:bundleId] = ENV['BUNDLE_ID'] if ENV['BUNDLE_ID']
          capabilities[:xcodeOrgId] = ENV['TEAM_ID'] if ENV['TEAM_ID']
          capabilities[:xcodeSigningId] = ENV['TEAM_NAME'] if ENV['TEAM_NAME']
          capabilities[:appActivity] = ENV['APP_ACTIVITY'] if ENV['APP_ACTIVITY']
          capabilities[:appPackage] = ENV['APP_PACKAGE'] if ENV['APP_PACKAGE']
        else
          Environ.device = :simulator
        end

        if ENV['APP']
          capabilities[:app] = ENV['APP']
        else
          if Environ.is_android?
            capabilities[:app] = Environ.current.android_apk_path
          elsif Environ.is_ios?
            if Environ.is_device?
              capabilities[:app] = Environ.current.ios_ipa_path
            else
              capabilities[:app] = Environ.current.ios_app_path
            end
          end
        end

      else
        base_path = 'config'
        unless File.directory?(File.join(project_path, base_path))
          raise 'Could not find appium.txt files in /config folder'
        end
        appium_caps = File.join(project_path, base_path, 'appium.txt')
        desired_capabilities = Appium.load_appium_txt file: appium_caps
      end

      puts "desired_capabilities = #{desired_capabilities}"

      Appium::Driver.new(desired_capabilities).start_driver
      @running = true
    end

    def self.start_driver
      unless @running
        $driver.start_driver
        @running = true
      end
    end

    def self.quit_driver
      if @running
        $driver.driver_quit
        @running = false
      end
    end

    def self.driver
      $driver
    end

    def self.take_screenshot(png_save_path)
      FileUtils.mkdir_p(File.dirname(png_save_path))
      $driver.driver.save_screenshot(png_save_path)
    end
  end
end

