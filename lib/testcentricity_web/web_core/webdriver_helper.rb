require 'selenium-webdriver'
require 'os'
require 'browserstack/local'
require 'fileutils'


module TestCentricity
  class WebDriverConnect
    include Capybara::DSL

    attr_accessor :bs_local
    attr_accessor :initialized
    attr_accessor :downloads_path
    attr_accessor :endpoint
    attr_accessor :capabilities
    attr_accessor :drivers

    def self.initialize_web_driver(options = nil)
      @initialized ||= false
      initialize_downloads unless @initialized
      @endpoint = nil
      @capabilities = nil
      Environ.driver_name = nil
      Environ.device_orientation = nil
      if options.is_a?(String)
        Capybara.app_host = options
      elsif options.is_a?(Hash)
        Capybara.app_host = options[:app_host] if options.key?(:app_host)
        @endpoint = options[:endpoint] if options.key?(:endpoint)
        @capabilities = options[:capabilities] if options.key?(:capabilities)
        Environ.driver = options[:driver] if options.key?(:driver)
        Environ.driver_name = options[:driver_name] if options.key?(:driver_name)
        Environ.device_type = options[:device_type] if options.key?(:device_type)
        Environ.browser_size = if options.key?(:browser_size)
          options[:browser_size]
        else
          ENV['BROWSER_SIZE'] if ENV['BROWSER_SIZE']
        end
      end
      # determine browser type and driver
      if @capabilities.nil?
        Environ.driver = ENV['DRIVER'].downcase.to_sym if ENV['DRIVER']
        Environ.browser = ENV['WEB_BROWSER'] if ENV['WEB_BROWSER']
        Environ.device_orientation = ENV['ORIENTATION'] if ENV['ORIENTATION']
      else
        if @capabilities[:browserName]
          Environ.browser = @capabilities[:browserName]
        else
          raise 'Missing :browserName in @capabilities'
        end
        Environ.device_orientation = @capabilities[:orientation] if @capabilities[:orientation]
        Environ.device_orientation = @capabilities[:'appium:orientation'] if @capabilities[:'appium:orientation']
      end
      Environ.browser = Environ.browser.downcase.to_sym if Environ.browser.is_a?(String)
      Environ.driver = :webdriver if Environ.driver.nil?
      Environ.device_type = ENV['DEVICE_TYPE'] if ENV['DEVICE_TYPE']
      # assume that we're testing within a local desktop web browser
      unless Environ.driver == :custom
        Environ.platform    = :desktop
        Environ.headless    = false
        Environ.device      = :web
        Environ.device_name = 'browser'
      end

      context = case Environ.driver
                when :appium
                  initialize_appium
                  "#{Environ.device_os} #{Environ.device_type} #{Environ.device} on Appium"
                when :webdriver
                  initialize_local_browser
                  'local browser instance'
                when :selenium_grid, :grid
                  initialize_remote
                  'Selenium Grid'
                when :browserstack
                  initialize_browserstack
                  'Browserstack cloud service'
                when :testingbot
                  initialize_testingbot
                  'TestingBot cloud service'
                  # :nocov:
                when :saucelabs
                  initialize_saucelabs
                  'Sauce Labs cloud service'
                when :lambdatest
                  initialize_lambdatest
                  'LambdaTest cloud service'
                  # :nocov:
                when :custom
                  raise 'User-defined webdriver requires that you define options' if options.nil?

                  initialize_custom_driver
                  'custom user-defined webdriver'
                else
                  raise "#{Environ.driver} is not a supported driver"
                end

      # set browser window size only if testing with a desktop web browser
      unless Environ.is_device? || Environ.is_simulator? || Environ.driver == :appium
        initialize_browser_size
      end

      # set Capybara's server port if PARALLEL_PORT is true
      Capybara.server_port = 9887 + ENV['TEST_ENV_NUMBER'].to_i if Environ.parallel

      Environ.session_state = :running
      puts "Using #{Environ.browser} browser via #{context}"
      # add the new driver to the driver queue
      @drivers[Environ.driver_name] = Environ.driver_state
    end

    def self.driver_exists?(driver_name)
      if @drivers.nil?
        false
      else
        driver_name = driver_name.gsub(/\s+/, '_').downcase.to_sym if driver_name.is_a?(String)
        driver_state = @drivers[driver_name]
        !driver_state.nil?
      end
    end

    def self.activate_driver(name)
      name = name.gsub(/\s+/, '_').downcase.to_sym if name.is_a?(String)
      return if Environ.driver_name == name

      driver_state = @drivers[name]
      raise "Could not find a driver named '#{name}'" if driver_state.nil?

      Environ.restore_driver_state(driver_state)
      Capybara.current_driver = name
      Capybara.default_driver = name
      Environ.driver_name = name
    end

    # Return the number of driver instances
    #
    # @return [Integer]
    def self.num_drivers
      @drivers.nil? ? 0 : @drivers.length
    end

    # Close all browsers and terminate all driver instances
    def self.close_all_drivers
      return if @drivers.nil?
      @drivers.each do |key, _value|
        Environ.restore_driver_state(@drivers[key])
        Capybara.current_driver = key
        Capybara.default_driver = key
        Capybara.page.driver.quit
        Capybara.current_session.quit
        @drivers.delete(key)
      end
      Capybara.reset_sessions!
      Environ.session_state = :quit
      Capybara.current_driver = nil
      @drivers = {}
      @initialized = false
    end

    def self.downloads_path
      @downloads_path
    end

    def self.initialize_browser_size
      # tile browser windows if BROWSER_TILE environment variable is true and running in multiple parallel threads
      if ENV['BROWSER_TILE'] && (Environ.parallel || @drivers.length > 1)
        thread = if Environ.parallel
                   ENV['TEST_ENV_NUMBER'].to_i
                 else
                   @drivers.length
                 end
        if thread > 1
          Browsers.set_browser_window_position(100 * thread - 1, 100 * thread - 1)
          sleep(1)
        end
      else
        Browsers.set_browser_window_position(10, 10)
        sleep(1)
      end

      browser = Environ.browser.to_s
      if Environ.is_desktop?
        case
        when ENV['BROWSER_SIZE'] == 'max'
          Browsers.maximize_browser
        when ENV['BROWSER_SIZE']
          Browsers.set_browser_window_size(ENV['BROWSER_SIZE'])
        when Environ.browser_size == 'max'
          Browsers.maximize_browser
        when Environ.browser_size
          Browsers.set_browser_window_size(Environ.browser_size)
        else
          Browsers.set_browser_window_size(Browsers.browser_size(browser, Environ.device_orientation))
        end
      elsif Environ.is_mobile? && !Environ.is_device?
        Browsers.set_browser_window_size(Browsers.browser_size(browser, Environ.device_orientation))
      end
      Environ.session_state = :running
    end

    # :nocov:

    def self.set_domain(url)
      Capybara.app_host = url
    end

    def self.close_tunnel
      unless @bs_local.nil?
        @bs_local.stop
        if @bs_local.isRunning
          raise 'BrowserStack Local instance could not be stopped'
        else
          puts 'BrowserStack Local instance has been stopped'
        end
      end
    end
    # :nocov:

    private

    def self.initialize_downloads
      @drivers = {}
      @downloads_path = "#{Dir.pwd}/downloads"
      # create downloads folder if it doesn't already exist
      if ENV['DOWNLOADS'] && ENV['DOWNLOADS'].to_bool
        Dir.mkdir(@downloads_path) unless Dir.exist?(@downloads_path)
      end

      if ENV['PARALLEL']
        Environ.parallel = true
        Environ.process_num = ENV['TEST_ENV_NUMBER']
        Environ.process_num = '1' if Environ.process_num.blank?
        if Dir.exist?(@downloads_path)
          @downloads_path = "#{@downloads_path}/#{Environ.process_num}"
          Dir.mkdir(@downloads_path) unless Dir.exist?(@downloads_path)
        end
      else
        Environ.parallel = false
      end
      @downloads_path = @downloads_path.tr('/', "\\") if OS.windows?
      @initialized = true
    end

    def self.initialize_appium
      Environ.platform = :mobile
      Environ.device = :simulator
      # define capabilities
      caps = if @capabilities.nil?
               Environ.browser = ENV['APP_BROWSER']
               Environ.device_name = ENV['APP_DEVICE']
               Environ.device_os = ENV['APP_PLATFORM_NAME'].downcase.to_sym
               Environ.device_os_version = ENV['APP_VERSION']
               caps = {
                 platformName: Environ.device_os,
                 browserName: Environ.browser,
                 'appium:platformVersion': Environ.device_os_version,
                 'appium:deviceName': Environ.device_name
               }
               caps[:'appium:avd'] = ENV['APP_DEVICE'] if Environ.device_os == :android
               caps[:'appium:automationName'] = ENV['AUTOMATION_ENGINE'] if ENV['AUTOMATION_ENGINE']
               if ENV['UDID']
                 # :nocov:
                 Environ.device = :device
                 caps[:'appium:udid'] = ENV['UDID']
                 caps[:'appium:xcodeOrgId'] = ENV['TEAM_ID'] if ENV['TEAM_ID']
                 caps[:'appium:xcodeSigningId'] = ENV['TEAM_NAME'] if ENV['TEAM_NAME']
                 # :nocov:
               else
                 caps[:'appium:orientation'] = Environ.device_orientation.upcase if Environ.device_orientation
                 if Environ.device_os == :ios
                   caps[:'appium:language'] = Environ.language if Environ.language
                   caps[:'appium:locale'] = Environ.locale.gsub('-', '_') if Environ.locale
                 end
               end
               caps[:'appium:safariIgnoreFraudWarning'] = ENV['APP_IGNORE_FRAUD_WARNING'] if ENV['APP_IGNORE_FRAUD_WARNING']
               caps[:'appium:safariInitialUrl'] = ENV['APP_INITIAL_URL'] if ENV['APP_INITIAL_URL']
               caps[:'appium:safariAllowPopups'] = ENV['APP_ALLOW_POPUPS'] if ENV['APP_ALLOW_POPUPS']
               caps[:'appium:shutdownOtherSimulators'] = ENV['SHUTDOWN_OTHER_SIMS'] if ENV['SHUTDOWN_OTHER_SIMS']
               caps[:'appium:forceSimulatorSoftwareKeyboardPresence'] = ENV['SHOW_SIM_KEYBOARD'] if ENV['SHOW_SIM_KEYBOARD']

               caps[:'appium:autoAcceptAlerts'] = ENV['AUTO_ACCEPT_ALERTS'] if ENV['AUTO_ACCEPT_ALERTS']
               caps[:'appium:autoDismissAlerts'] = ENV['AUTO_DISMISS_ALERTS'] if ENV['AUTO_DISMISS_ALERTS']
               caps[:'appium:isHeadless'] = ENV['HEADLESS'] if ENV['HEADLESS']

               caps[:'appium:newCommandTimeout'] = ENV['NEW_COMMAND_TIMEOUT'] if ENV['NEW_COMMAND_TIMEOUT']
               caps[:'appium:noReset'] = ENV['APP_NO_RESET'] if ENV['APP_NO_RESET']
               caps[:'appium:fullReset'] = ENV['APP_FULL_RESET'] if ENV['APP_FULL_RESET']
               caps[:'appium:webkitDebugProxyPort'] = ENV['WEBKIT_DEBUG_PROXY_PORT'] if ENV['WEBKIT_DEBUG_PROXY_PORT']
               caps[:'appium:webDriverAgentUrl'] = ENV['WEBDRIVER_AGENT_URL'] if ENV['WEBDRIVER_AGENT_URL']
               caps[:'appium:usePrebuiltWDA'] = ENV['USE_PREBUILT_WDA'] if ENV['USE_PREBUILT_WDA']
               caps[:'appium:useNewWDA'] = ENV['USE_NEW_WDA'] if ENV['USE_NEW_WDA']
               caps[:'appium:chromedriverExecutable'] = ENV['CHROMEDRIVER_EXECUTABLE'] if ENV['CHROMEDRIVER_EXECUTABLE']
               # set wdaLocalPort (iOS) or systemPort (Android) if PARALLEL_PORT is true
               if Environ.parallel
                 # :nocov:
                 if Environ.device_os == :ios
                   caps[:'appium:wdaLocalPort'] = 8100 + ENV['TEST_ENV_NUMBER'].to_i
                 else
                   caps[:'appium:systemPort'] = 8200 + ENV['TEST_ENV_NUMBER'].to_i
                 end
                 # :nocov:
               else
                 caps[:'appium:wdaLocalPort'] = ENV['WDA_LOCAL_PORT'] if ENV['WDA_LOCAL_PORT']
                 caps[:'appium:systemPort'] = ENV['SYSTEM_PORT'] if ENV['SYSTEM_PORT']
               end
               caps
             else
               Environ.device_os = @capabilities[:platformName]
               Environ.device_os_version = @capabilities[:'appium:platformVersion']
               Environ.device_name = @capabilities[:'appium:deviceName']
               @capabilities
             end
      # specify endpoint url
      if @endpoint.nil?
        @endpoint = if ENV['APPIUM_SERVER_VERSION'] && ENV['APPIUM_SERVER_VERSION'].to_i == 1
                      'http://127.0.0.1:4723/wd/hub'
                    else
                      'http://127.0.0.1:4723'
                    end
      end
      register_remote_driver(Environ.browser, caps)
    end

    def self.initialize_local_browser
      Environ.os = case
                   when OS.osx?
                     'OS X'
                     # :nocov:
                   when OS.windows?
                     'Windows'
                   when OS.linux?
                     'Linux'
                   else
                     'unknown'
                     # :nocov:
                   end
      case Environ.browser
      when :firefox, :chrome, :safari, :edge, :chrome_headless, :firefox_headless, :edge_headless
        Environ.platform = :desktop
      else
        Environ.platform = :mobile
        Environ.device_name = Browsers.mobile_device_name(Environ.browser)
      end

      Capybara.register_driver driver_name do |app|
        browser = Environ.browser
        case browser
        when :safari
          Capybara::Selenium::Driver.new(app, browser: browser)
        when :firefox, :firefox_headless
          options = firefox_options(browser)
          Capybara::Selenium::Driver.new(app, browser: :firefox, options: options)
        when :chrome, :chrome_headless
          options = chrome_edge_options(browser)
          Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
        when :edge, :edge_headless
          options = chrome_edge_options(browser)
          Capybara::Selenium::Driver.new(app, browser: :edge, options: options)
        else
          user_agent = Browsers.mobile_device_agent(Environ.browser)
          options = Selenium::WebDriver::Chrome::Options.new(exclude_switches: ['enable-automation'])
          options.add_argument('--disable-dev-shm-usage')
          options.add_argument("--user-agent='#{user_agent}'")
          options.add_argument("--lang=#{ENV['LOCALE']}") if ENV['LOCALE']
          Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
        end
      end
      Capybara.default_driver = Environ.driver_name
    end

    def self.initialize_remote
      Environ.grid = :selenium_grid
      browser = Environ.browser
      @endpoint = if @endpoint.nil?
                    ENV['REMOTE_ENDPOINT'] if ENV['REMOTE_ENDPOINT']
                  else
                    'http://localhost:4444/wd/hub'
                  end
      case browser
        # :nocov:
      when :safari
        options = Selenium::WebDriver::Safari::Options.new
        # :nocov:
      when :firefox, :firefox_headless
        options = firefox_options(browser)
      when :chrome, :chrome_headless, :edge, :edge_headless
        options = chrome_edge_options(browser)
      else
        Environ.platform = :mobile
        Environ.device_name = Browsers.mobile_device_name(Environ.browser)
        user_agent = Browsers.mobile_device_agent(Environ.browser)
        options = Selenium::WebDriver::Chrome::Options.new
        options.add_argument('--disable-dev-shm-usage')
        options.add_argument("--user-agent='#{user_agent}'")
        options.add_argument("--lang=#{ENV['LOCALE']}") if ENV['LOCALE']
      end

      Capybara.register_driver driver_name do |app|
        Capybara::Selenium::Driver.new(app,
                                       browser: :remote,
                                       url: @endpoint,
                                       options: options).tap do |driver|
          # configure file_detector for remote uploads
          driver.browser.file_detector = lambda do |args|
            str = args.first.to_s
            str if File.exist?(str)
          end
        end
      end
      Capybara.current_driver = Environ.driver_name
      Capybara.default_driver = Environ.driver_name
    end

    def self.initialize_browserstack
      # determine browser type
      Environ.browser = if @capabilities.nil?
                          ENV['BS_BROWSER'] if ENV['BS_BROWSER']
                        else
                          @capabilities[:browserName]
                        end
      browser = Environ.browser
      Environ.grid = :browserstack
      if ENV['BS_REAL_MOBILE'] || ENV['BS_DEVICE']
        Environ.platform    = :mobile
        Environ.device_name = ENV['BS_DEVICE']
        Environ.device_os   = ENV['BS_OS']
        Environ.device = if ENV['BS_REAL_MOBILE']
                           :device
                         else
                           :simulator
                         end
      end
      # specify endpoint url
      @endpoint = "https://#{ENV['BS_USERNAME']}:#{ENV['BS_AUTHKEY']}@hub-cloud.browserstack.com/wd/hub" if @endpoint.nil?
      # :nocov:
      # enable tunneling if specified
      if ENV['TUNNELING']
        @bs_local = BrowserStack::Local.new
        bs_local_args = {'key' => "#{ENV['BS_AUTHKEY']}"}
        @bs_local.start(bs_local_args)
        if @bs_local.isRunning
          puts 'BrowserStack Local instance has been started'
        else
          puts 'BrowserStack Local instance failed to start'
        end
      end
      # :nocov:
      # define BrowserStack options
      options = if @capabilities.nil?
                  Environ.os = "#{ENV['BS_OS']} #{ENV['BS_OS_VERSION']}"
                  browser_options = {}
                  # define the required set of BrowserStack options
                  bs_options = {
                    userName: ENV['BS_USERNAME'],
                    accessKey: ENV['BS_AUTHKEY'],
                    sessionName: test_context_message,
                    os: ENV['BS_OS'],
                    osVersion: ENV['BS_OS_VERSION']
                  }
                  # define browser specific BrowserStack options
                  case browser.downcase.to_sym
                  when :safari
                    browser_options[:enablePopups] = ENV['ALLOW_POPUPS'] if ENV['ALLOW_POPUPS']
                    browser_options[:allowAllCookies] = ENV['ALLOW_COOKIES'] if ENV['ALLOW_COOKIES']
                    bs_options[:safari] = browser_options unless browser_options.empty?
                  when :ie
                    browser_options[:enablePopups] = ENV['ALLOW_POPUPS'] if ENV['ALLOW_POPUPS']
                    bs_options[:ie] = browser_options unless browser_options.empty?
                  when :edge
                    browser_options[:enablePopups] = ENV['ALLOW_POPUPS'] if ENV['ALLOW_POPUPS']
                    bs_options[:edge] = browser_options unless browser_options.empty?
                  end
                  # define the optional BrowserStack options
                  bs_options[:projectName] = ENV['AUTOMATE_PROJECT'] if ENV['AUTOMATE_PROJECT']
                  bs_options[:buildName] = ENV['AUTOMATE_BUILD'] if ENV['AUTOMATE_BUILD']
                  bs_options[:headless] = ENV['HEADLESS'] if ENV['HEADLESS']
                  bs_options[:timezone] = ENV['TIME_ZONE'] if ENV['TIME_ZONE']
                  bs_options[:geoLocation] = ENV['IP_GEOLOCATION'] if ENV['IP_GEOLOCATION']
                  bs_options[:video] = ENV['RECORD_VIDEO'] if ENV['RECORD_VIDEO']
                  bs_options[:debug] = ENV['SCREENSHOTS'] if ENV['SCREENSHOTS']
                  bs_options[:networkLogs] = ENV['NETWORK_LOGS'] if ENV['NETWORK_LOGS']
                  bs_options[:local] = ENV['TUNNELING'] if ENV['TUNNELING']
                  bs_options[:deviceOrientation] = ENV['ORIENTATION'] if ENV['ORIENTATION']
                  bs_options[:appiumLogs] = ENV['APPIUM_LOGS'] if ENV['APPIUM_LOGS']
                  bs_options[:realMobile] = ENV['BS_REAL_MOBILE'] if ENV['BS_REAL_MOBILE']
                  # define mobile device options
                  if ENV['BS_DEVICE']
                    bs_options[:deviceName] = ENV['BS_DEVICE']
                    bs_options[:appiumVersion] = '2.6.0'
                    {
                      browserName: browser,
                      'bstack:options': bs_options
                    }
                  else
                    # define desktop browser options
                    bs_options[:resolution] = ENV['RESOLUTION'] if ENV['RESOLUTION']
                    bs_options[:seleniumVersion] = '4.24.0'
                    {
                      browserName: browser,
                      browserVersion: ENV['BS_VERSION'],
                      'bstack:options': bs_options
                    }
                  end
                else
                  bs_options = @capabilities[:'bstack:options']
                  Environ.os = "#{bs_options[:os]} #{bs_options[:osVersion]}"
                  if bs_options.key?(:deviceName)
                    Environ.platform = :mobile
                    Environ.device_name = bs_options[:deviceName]
                    Environ.device_os = bs_options[:osVersion]
                    Environ.device = if bs_options.key?(:realMobile)
                                       :device
                                     else
                                       :simulator
                                     end
                    Environ.device_orientation = bs_options[:deviceOrientation] if bs_options.key?(:deviceOrientation)
                  end
                  @capabilities
                end
      register_remote_driver(browser, options)
      # configure file_detector for remote uploads if target is desktop web browser
      config_file_uploads if Environ.platform == :desktop
      Environ.tunneling = ENV['TUNNELING'] if ENV['TUNNELING']
    end

    def self.initialize_testingbot
      # determine browser type
      Environ.browser = if @capabilities.nil?
                          ENV['TB_BROWSER'] if ENV['TB_BROWSER']
                        else
                          @capabilities[:browserName]
                        end
      browser = Environ.browser
      Environ.grid = :testingbot
      if ENV['TB_PLATFORM']
        Environ.device_os = ENV['TB_PLATFORM']
        Environ.device_name = ENV['TB_DEVICE']
        Environ.platform = :mobile
        Environ.device = :simulator
      else
        Environ.platform = :desktop
      end
      # specify endpoint url
      if @endpoint.nil?
        url = ENV['TUNNELING'] ? '@localhost:4445/wd/hub' : '@hub.testingbot.com/wd/hub'
        @endpoint = "https://#{ENV['TB_USERNAME']}:#{ENV['TB_AUTHKEY']}#{url}"
      end
      # define TestingBot options
      options = if @capabilities.nil?
                  Environ.os = ENV['TB_OS']
                  # define the required set of TestingBot options
                  tb_options = { build: test_context_message }
                  # define the optional TestingBot options
                  tb_options[:name] = ENV['AUTOMATE_PROJECT'] if ENV['AUTOMATE_PROJECT']
                  tb_options[:timeZone] = ENV['TIME_ZONE'] if ENV['TIME_ZONE']
                  tb_options['testingbot.geoCountryCode'] = ENV['GEO_LOCATION'] if ENV['GEO_LOCATION']
                  tb_options[:screenrecorder] = ENV['RECORD_VIDEO'] if ENV['RECORD_VIDEO']
                  tb_options[:screenshot] = ENV['SCREENSHOTS'] if ENV['SCREENSHOTS']
                  # define mobile device options
                  if ENV['TB_PLATFORM']
                    tb_options[:platform] = ENV['TB_PLATFORM']
                    tb_options[:orientation] = ENV['ORIENTATION'].upcase if ENV['ORIENTATION']
                    tb_options[:deviceName] = ENV['TB_DEVICE'] if ENV['TB_DEVICE']
                  else
                    # define desktop browser options
                    tb_options['screen-resolution'] = ENV['RESOLUTION'] if ENV['RESOLUTION']
                    tb_options['selenium-version'] = '4.25.0'
                  end
                  {
                    browserName: browser,
                    browserVersion: ENV['TB_VERSION'],
                    platformName: ENV['TB_OS'],
                    'tb:options': tb_options
                  }
                else
                  tb_options = @capabilities[:'tb:options']
                  Environ.os = @capabilities[:platformName]
                  if tb_options.key?(:deviceName)
                    Environ.platform = :mobile
                    Environ.device_name = tb_options[:deviceName]
                    Environ.device_os = @capabilities[:browserVersion]
                    Environ.device_orientation = tb_options[:orientation] if tb_options.key?(:orientation)
                    Environ.device = :simulator
                  end
                  @capabilities
                end
      register_remote_driver(browser, options)
      # configure file_detector for remote uploads if target is desktop web browser
      config_file_uploads if Environ.platform == :desktop
    end

    # :nocov:
    def self.initialize_saucelabs
      # determine browser type
      Environ.browser = if @capabilities.nil?
                          ENV['SL_BROWSER'] if ENV['SL_BROWSER']
                        else
                          @capabilities[:browserName]
                        end
      browser = Environ.browser
      Environ.grid = :saucelabs

      if ENV['SL_PLATFORM']
        Environ.device_name = ENV['SL_DEVICE']
        Environ.platform = :mobile
        Environ.device = :simulator
      elsif ENV['SL_OS']
        Environ.platform = :desktop
        Environ.os = ENV['SL_OS']
      end
      # specify endpoint url
      if @endpoint.nil?
        @endpoint = "https://#{ENV['SL_USERNAME']}:#{ENV['SL_AUTHKEY']}@ondemand.#{ENV['SL_DATA_CENTER']}.saucelabs.com:443/wd/hub"
      end
      # define SauceLab options
      options = if @capabilities.nil?
                  # define the required set of SauceLab options
                  sl_options = {
                    username: ENV['SL_USERNAME'],
                    access_key: ENV['SL_AUTHKEY'],
                    build: test_context_message
                  }
                  # define the optional SauceLab options
                  sl_options[:name] = ENV['AUTOMATE_PROJECT'] if ENV['AUTOMATE_PROJECT']
                  sl_options[:recordVideo] = ENV['RECORD_VIDEO'] if ENV['RECORD_VIDEO']
                  sl_options[:recordScreenshots] = ENV['SCREENSHOTS'] if ENV['SCREENSHOTS']
                  # define mobile device options
                  if ENV['SL_PLATFORM']
                    sl_options[:deviceOrientation] = ENV['ORIENTATION'].upcase if ENV['ORIENTATION']
                    sl_options[:appium_version] = '2.1.3'
                    {
                      browserName: browser,
                      platform_name: ENV['SL_PLATFORM'],
                      'appium:deviceName': ENV['SL_DEVICE'],
                      'appium:platformVersion': ENV['SL_VERSION'],
                      'appium:automationName': ENV['AUTOMATION_ENGINE'],
                      'sauce:options': sl_options
                    }
                  else
                    # define desktop browser options
                    sl_options[:screenResolution] = ENV['RESOLUTION'] if ENV['RESOLUTION']
                    {
                      browserName: browser,
                      browser_version: ENV['SL_VERSION'],
                      platform_name: ENV['SL_OS'],
                      'sauce:options': sl_options
                    }
                  end
                else
                  sl_options = @capabilities[:'sauce:options']
                  Environ.os = @capabilities[:platform_name]
                  if @capabilities.key?(:'appium:deviceName')
                    Environ.platform = :mobile
                    Environ.device_name = @capabilities[:'appium:deviceName']
                    Environ.device_os = @capabilities[:'appium:platformVersion']
                    Environ.device = :simulator
                    Environ.device_orientation = sl_options[:deviceOrientation] if sl_options.key?(:deviceOrientation)
                  end
                  @capabilities
                end
      register_remote_driver(browser, options)
      # configure file_detector for remote uploads
      config_file_uploads if Environ.platform == :desktop
    end

    def self.initialize_lambdatest
      # determine browser type
      Environ.browser = if @capabilities.nil?
                          ENV['LT_BROWSER'] if ENV['LT_BROWSER']
                        else
                          @capabilities[:browserName]
                        end
      browser = Environ.browser
      Environ.grid = :lambdatest
      Environ.platform = :desktop
      Environ.tunneling = ENV['TUNNELING'] if ENV['TUNNELING']
      # specify endpoint url
      @endpoint = "https://#{ENV['LT_USERNAME']}:#{ENV['LT_AUTHKEY']}@hub.lambdatest.com/wd/hub" if @endpoint.nil?
      # define LambdaTest options
      options = if @capabilities.nil?
                  Environ.os = ENV['LT_OS']
                  # define the required set of LambdaTest options
                  lt_options = {
                    username: ENV['LT_USERNAME'],
                    accessKey: ENV['LT_AUTHKEY'],
                    platformName: ENV['LT_OS'],
                    resolution: ENV['RESOLUTION'],
                    name: test_context_message,
                    selenium_version: '4.25.0',
                    w3c: true
                  }
                  # define the optional LambdaTest options
                  lt_options[:project] = ENV['AUTOMATE_PROJECT'] if ENV['AUTOMATE_PROJECT']
                  lt_options[:build] = ENV['AUTOMATE_BUILD'] if ENV['AUTOMATE_BUILD']
                  lt_options[:headless] = ENV['HEADLESS'] if ENV['HEADLESS']
                  lt_options[:timezone] = ENV['TIME_ZONE'] if ENV['TIME_ZONE']
                  lt_options[:geoLocation] = ENV['GEO_LOCATION'] if ENV['GEO_LOCATION']
                  lt_options[:video] = ENV['RECORD_VIDEO'] if ENV['RECORD_VIDEO']
                  lt_options[:visual] = ENV['SCREENSHOTS'] if ENV['SCREENSHOTS']
                  lt_options[:network] = ENV['NETWORK_LOGS'] if ENV['NETWORK_LOGS']
                  lt_options[:tunnel] = ENV['TUNNELING'] if ENV['TUNNELING']
                  # define browser specific LambdaTest options
                  case browser.downcase.to_sym
                  when :safari
                    lt_options['safari.popups'] = ENV['ALLOW_POPUPS'] if ENV['ALLOW_POPUPS']
                    lt_options['safari.cookies'] = ENV['ALLOW_COOKIES'] if ENV['ALLOW_COOKIES']
                  when :ie
                    lt_options['ie.popups'] = ENV['ALLOW_POPUPS'] if ENV['ALLOW_POPUPS']
                  when :microsoftedge
                    lt_options['edge.popups'] = ENV['ALLOW_POPUPS'] if ENV['ALLOW_POPUPS']
                  end
                  {
                    browserName: browser,
                    browserVersion: ENV['LT_VERSION'],
                    'LT:Options': lt_options
                  }
                else
                  Environ.os = @capabilities[:platform_name]
                  @capabilities
                end
      register_remote_driver(browser, options)
      # configure file_detector for remote uploads
      config_file_uploads if Environ.platform == :desktop
    end
    # :nocov:

    def self.initialize_custom_driver
      raise 'User-defined webdriver requires that you provide capabilities' if @capabilities.nil?
      raise 'User-defined webdriver requires that you provide an endpoint' if @endpoint.nil?

      Environ.browser = @capabilities[:browserName]
      Environ.grid = :custom
      register_remote_driver(Environ.browser, @capabilities)
    end

    def self.chrome_edge_options(browser)
      options = case browser
                when :chrome, :chrome_headless
                  Selenium::WebDriver::Chrome::Options.new(exclude_switches: ['enable-automation'])
                when :edge, :edge_headless
                  Selenium::WebDriver::Edge::Options.new(exclude_switches: ['enable-automation'])
                else
                  raise "#{browser} is not a valid selector"
                end
      prefs = {
        prompt_for_download: false,
        directory_upgrade:   true,
        default_directory:   @downloads_path
      }
      options.add_preference(:download, prefs)
      options.add_argument('--force-device-scale-factor=1')
      options.add_argument('--disable-search-engine-choice-screen')
      options.add_argument('--disable-geolocation')
      options.add_argument('--disable-dev-shm-usage')
      options.add_argument('--no-sandbox')
      options.add_argument("--lang=#{ENV['LOCALE']}") if ENV['LOCALE']
      if browser == :chrome_headless || browser == :edge_headless
        Environ.headless = true
        options.add_argument('--headless=new')
        options.add_argument('--disable-gpu')
      end
      options
    end

    def self.firefox_options(browser)
      profile = Selenium::WebDriver::Firefox::Profile.new
      profile['browser.download.dir'] = @downloads_path
      profile['browser.download.folderList'] = 2
      profile['browser.download.manager.showWhenStarting'] = false
      profile['browser.download.manager.closeWhenDone'] = true
      profile['browser.download.manager.showAlertOnComplete'] = false
      profile['browser.download.manager.alertOnEXEOpen'] = false
      profile['browser.download.manager.useWindow'] = false
      profile['browser.helperApps.alwaysAsk.force'] = false
      profile['pdfjs.disabled'] = true

      mime_types = ENV['MIME_TYPES'] || 'images/jpeg, application/pdf, application/octet-stream'
      profile['browser.helperApps.neverAsk.saveToDisk'] = mime_types

      profile['intl.accept_languages'] = ENV['LOCALE'] if ENV['LOCALE']
      options = Selenium::WebDriver::Firefox::Options.new(profile: profile)
      if browser == :firefox_headless
        Environ.headless = true
        options.args << '--headless'
      end
      options
    end

    def self.test_context_message
      context_message = if ENV['TEST_CONTEXT']
                          "#{Environ.test_environment.to_s.upcase} - #{ENV['TEST_CONTEXT']}"
                        else
                          Environ.test_environment.to_s.upcase
                        end
      if Environ.parallel
        thread_num = ENV['TEST_ENV_NUMBER']
        thread_num = 1 if thread_num.blank?
        context_message = "#{context_message} - Thread ##{thread_num}"
      end
      context_message
    end

    def self.driver_name
      unless Environ.driver_name
        driver = case Environ.driver
                 when :webdriver
                   :local
                 when :selenium_grid, :grid
                   :remote
                 else
                   Environ.driver
                 end
        Environ.driver_name = "#{driver}_#{Environ.browser}".downcase.to_sym unless driver.nil?
      end
      Environ.driver_name
    end

    def self.register_remote_driver(browser, options)
      Capybara.register_driver driver_name do |app|
        browser = browser.gsub(/\s+/, '_').downcase.to_sym if browser.is_a?(String)
        capabilities = Selenium::WebDriver::Remote::Capabilities.new(options)
        Capybara::Selenium::Driver.new(app,
                                       browser: :remote,
                                       url: @endpoint,
                                       capabilities: capabilities)
      end

      Environ.browser = browser

      Capybara.default_driver = Environ.driver_name
      Capybara.current_driver = Environ.driver_name
      Capybara.run_server = false
    end

    def self.config_file_uploads
      # configure file_detector for remote uploads
      selenium = Capybara.page.driver.browser
      selenium.file_detector = lambda do |args|
        str = args.first.to_s
        str if File.exist?(str)
      end
    end
  end
end
