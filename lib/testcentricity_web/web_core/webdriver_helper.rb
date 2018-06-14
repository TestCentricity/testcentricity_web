require 'selenium-webdriver'
require 'os'
require 'browserstack/local'


module TestCentricity
  module WebDriverConnect
    include Capybara::DSL

    attr_accessor :webdriver_path
    attr_accessor :bs_local

    def self.initialize_web_driver(app_host = nil)
      Capybara.app_host = app_host unless app_host.nil?
      browser = ENV['WEB_BROWSER']

      # assume that we're testing within a local desktop web browser
      Environ.driver      = :webdriver
      Environ.platform    = :desktop
      Environ.browser     = browser
      Environ.headless    = false
      Environ.device      = :web
      Environ.device_name = 'browser'

      case browser.downcase.to_sym
      when :appium
        initialize_appium
        context = 'mobile device emulator'
      when :browserstack
        initialize_browserstack
        context = 'Browserstack cloud service'
      when :crossbrowser
        initialize_crossbrowser
        context = 'CrossBrowserTesting cloud service'
      when :gridlastic
        initialize_gridlastic
        context = 'Gridlastic cloud service'
      when :saucelabs
        initialize_saucelabs
        context = 'Sauce Labs cloud service'
      when :testingbot
        initialize_testingbot
        context = 'TestingBot cloud service'
      else
        if ENV['SELENIUM'] == 'remote'
          initialize_remote
          context = 'Selenium Grid2'
        else
          initialize_local_browser
          context = 'local browser instance'
        end
      end

      # set browser window size only if testing with a desktop web browser
      unless Environ.is_device? || Capybara.current_driver == :appium
        initialize_browser_size
      end

      Environ.session_state = :running
      puts "Using #{Environ.browser} browser via #{context}"
    end

    def self.set_domain(url)
      Capybara.app_host = url
    end

    # Set the WebDriver path for Chrome, Firefox, IE, or Edge browsers
    def self.set_webdriver_path(project_path)
      path_to_driver = nil
      # check for existence of /webdrivers or /features/support/drivers folders
      base_path = 'features/support/drivers'
      unless File.directory?(File.join(project_path, base_path))
        base_path = 'webdrivers'
        unless File.directory?(File.join(project_path, base_path))
          raise 'Could not find WebDriver files in /webdrivers or /features/support/drivers folders'
        end
      end
      # set WebDriver path based on browser and operating system
      case ENV['WEB_BROWSER'].downcase.to_sym
      when :chrome, :chrome_headless
        if OS.osx?
          path_to_driver = 'mac/chromedriver'
        elsif OS.windows?
          path_to_driver = 'windows/chromedriver.exe'
        end
        @webdriver_path = File.join(project_path, base_path, path_to_driver)
        Selenium::WebDriver::Chrome.driver_path = @webdriver_path
      when :firefox, :firefox_headless
        if OS.osx?
          path_to_driver = 'mac/geckodriver'
        elsif OS.windows?
          path_to_driver = 'windows/geckodriver.exe'
        end
        @webdriver_path = File.join(project_path, base_path, path_to_driver)
        Selenium::WebDriver::Firefox.driver_path = @webdriver_path
      when :ie
        path_to_driver = 'windows/IEDriverServer.exe'
        @webdriver_path = File.join(project_path, base_path, path_to_driver)
        Selenium::WebDriver::IE.driver_path = @webdriver_path
      when :edge
        path_to_driver = 'windows/MicrosoftWebDriver.exe'
        @webdriver_path = File.join(project_path, base_path, path_to_driver)
        Selenium::WebDriver::Edge.driver_path = @webdriver_path
      else
        if ENV['HOST_BROWSER']
          case ENV['HOST_BROWSER'].downcase.to_sym
          when :chrome
            if OS.osx?
              path_to_driver = 'mac/chromedriver'
            elsif OS.windows?
              path_to_driver = 'windows/chromedriver.exe'
            end
            @webdriver_path = File.join(project_path, base_path, path_to_driver)
            Selenium::WebDriver::Chrome.driver_path = @webdriver_path
          when :firefox
            if OS.osx?
              path_to_driver = 'mac/geckodriver'
            elsif OS.windows?
              path_to_driver = 'windows/geckodriver.exe'
            end
            @webdriver_path = File.join(project_path, base_path, path_to_driver)
            Selenium::WebDriver::Firefox.driver_path = @webdriver_path
          else
            raise "#{ENV['HOST_BROWSER']} is not a valid host browser for mobile browser emulation"
          end
        end
      end
      puts "The webdriver path is: #{@webdriver_path}" unless path_to_driver.nil?
    end

    def self.initialize_browser_size
      # tile browser windows if running in multiple parallel threads and BROWSER_TILE environment variable is true
      if ENV['PARALLEL'] && ENV['BROWSER_TILE']
        thread = ENV['TEST_ENV_NUMBER'].to_i
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
        if ENV['BROWSER_SIZE'] == 'max'
          Browsers.maximize_browser
        elsif ENV['BROWSER_SIZE']
          Browsers.set_browser_window_size(ENV['BROWSER_SIZE'])
        else
          Browsers.set_browser_window_size(Browsers.browser_size(browser, ENV['ORIENTATION']))
        end
      elsif Environ.is_mobile? && !Environ.is_device?
        Browsers.set_browser_window_size(Browsers.browser_size(browser, ENV['ORIENTATION']))
      end
      Environ.session_state = :running
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

    private

    def self.initialize_appium
      Environ.platform    = :mobile
      Environ.device_name = ENV['APP_DEVICE']
      Environ.device_os   = ENV['APP_PLATFORM_NAME']
      Environ.device_type = ENV['DEVICE_TYPE'] if ENV['DEVICE_TYPE']
      Environ.device_orientation = ENV['ORIENTATION'] if ENV['ORIENTATION']
      Capybara.default_driver = :appium
      endpoint = 'http://localhost:4723/wd/hub'
      desired_capabilities = {
          platformName:    ENV['APP_PLATFORM_NAME'],
          platformVersion: ENV['APP_VERSION'],
          browserName:     ENV['APP_BROWSER'],
          deviceName:      ENV['APP_DEVICE']
      }
      desired_capabilities[:avd] = ENV['APP_DEVICE'] if ENV['APP_PLATFORM_NAME'].downcase.to_sym == :android
      desired_capabilities[:automationName] = ENV['AUTOMATION_ENGINE'] if ENV['AUTOMATION_ENGINE']
      if ENV['UDID']
        Environ.device = :device
        desired_capabilities[:udid] = ENV['UDID']
        desired_capabilities[:startIWDP] = true
        desired_capabilities[:xcodeOrgId] = ENV['TEAM_ID'] if ENV['TEAM_ID']
        desired_capabilities[:xcodeSigningId] = ENV['TEAM_NAME'] if ENV['TEAM_NAME']
      else
        Environ.device = :simulator
        desired_capabilities[:orientation] = ENV['ORIENTATION'].upcase if ENV['ORIENTATION']
        if Environ.device_os == :ios
          desired_capabilities[:language] = ENV['LANGUAGE'] if ENV['LANGUAGE']
          desired_capabilities[:locale]   = ENV['LOCALE'].gsub('-', '_') if ENV['LOCALE']
        end
      end
      desired_capabilities[:safariIgnoreFraudWarning] = ENV['APP_IGNORE_FRAUD_WARNING'] if ENV['APP_IGNORE_FRAUD_WARNING']
      desired_capabilities[:safariInitialUrl]       = ENV['APP_INITIAL_URL'] if ENV['APP_INITIAL_URL']
      desired_capabilities[:safariAllowPopups]      = ENV['APP_ALLOW_POPUPS'] if ENV['APP_ALLOW_POPUPS']
      desired_capabilities[:newCommandTimeout]      = ENV['NEW_COMMAND_TIMEOUT'] if ENV['NEW_COMMAND_TIMEOUT']
      desired_capabilities[:noReset]                = ENV['APP_NO_RESET'] if ENV['APP_NO_RESET']
      desired_capabilities[:fullReset]              = ENV['APP_FULL_RESET'] if ENV['APP_FULL_RESET']
      desired_capabilities[:webkitDebugProxyPort]   = ENV['WEBKIT_DEBUG_PROXY_PORT'] if ENV['WEBKIT_DEBUG_PROXY_PORT']
      desired_capabilities[:webDriverAgentUrl]      = ENV['WEBDRIVER_AGENT_URL'] if ENV['WEBDRIVER_AGENT_URL']
      desired_capabilities[:wdaLocalPort]           = ENV['WDA_LOCAL_PORT'] if ENV['WDA_LOCAL_PORT']
      desired_capabilities[:usePrebuiltWDA]         = ENV['USE_PREBUILT_WDA'] if ENV['USE_PREBUILT_WDA']
      desired_capabilities[:useNewWDA]              = ENV['USE_NEW_WDA'] if ENV['USE_NEW_WDA']
      desired_capabilities[:chromedriverExecutable] = ENV['CHROMEDRIVER_EXECUTABLE'] if ENV['CHROMEDRIVER_EXECUTABLE']

      Capybara.register_driver :appium do |app|
        appium_lib_options = { server_url: endpoint }
        all_options = {
            appium_lib:  appium_lib_options,
            caps:        desired_capabilities
        }
        Appium::Capybara::Driver.new app, all_options
      end
    end

    def self.initialize_local_browser
      if OS.osx?
        Environ.os = 'OS X'
      elsif OS.windows?
        Environ.os = 'Windows'
      end

      browser = ENV['WEB_BROWSER'].downcase.to_sym

      case browser
      when :firefox, :chrome, :ie, :safari, :edge, :firefox_legacy
        Environ.platform = :desktop
      when :chrome_headless, :firefox_headless
        Environ.platform = :desktop
        Environ.headless = true
      else
        Environ.platform = :mobile
        Environ.device_name = Browsers.mobile_device_name(ENV['WEB_BROWSER'])
      end

      Capybara.register_driver :selenium do |app|
        case browser
        when :safari
          desired_caps = Selenium::WebDriver::Remote::Capabilities.safari(cleanSession: true)
          Capybara::Selenium::Driver.new(app, browser: browser, desired_capabilities: desired_caps)
        when :ie, :edge
          Capybara::Selenium::Driver.new(app, browser: browser)
        when :firefox_legacy
          Capybara::Selenium::Driver.new(app, browser: :firefox, marionette: false)
        when :firefox, :firefox_headless
          profile = Selenium::WebDriver::Firefox::Profile.new
          profile['browser.download.dir'] = '/tmp/webdriver-downloads'
          profile['browser.download.folderList'] = 2
          profile['browser.helperApps.neverAsk.saveToDisk'] = 'text/csv, application/x-msexcel, application/excel, application/x-excel, application/vnd.ms-excel, image/png, image/jpeg, text/html, text/plain, application/pdf, application/octet-stream'
          profile['pdfjs.disabled'] = true
          profile['intl.accept_languages'] = ENV['LOCALE'] if ENV['LOCALE']
          options = Selenium::WebDriver::Firefox::Options.new(profile: profile)
          options.args << '--headless' if browser == :firefox_headless
          if @webdriver_path.blank?
            Capybara::Selenium::Driver.new(app, browser: :firefox, options: options)
          else
            Capybara::Selenium::Driver.new(app, browser: :firefox, options: options, driver_path: @webdriver_path)
          end
        when :chrome, :chrome_headless
          (browser == :chrome) ?
              options = Selenium::WebDriver::Chrome::Options.new :
              options = Selenium::WebDriver::Chrome::Options.new(args: %w[headless disable-gpu no-sandbox])
          options.add_argument('--disable-infobars')
          options.add_argument("--lang=#{ENV['LOCALE']}") if ENV['LOCALE']
          Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
        else
          user_agent = Browsers.mobile_device_agent(ENV['WEB_BROWSER'])
          ENV['HOST_BROWSER'] ? host_browser = ENV['HOST_BROWSER'].downcase.to_sym : host_browser = :chrome
          case host_browser
          when :firefox
            profile = Selenium::WebDriver::Firefox::Profile.new
            profile['general.useragent.override'] = user_agent
            profile['intl.accept_languages'] = ENV['LOCALE'] if ENV['LOCALE']
            options = Selenium::WebDriver::Firefox::Options.new(profile: profile)
            if @webdriver_path.blank?
              Capybara::Selenium::Driver.new(app, browser: :firefox, options: options)
            else
              Capybara::Selenium::Driver.new(app, browser: :firefox, options: options, driver_path: @webdriver_path)
            end
          when :chrome
            options = Selenium::WebDriver::Chrome::Options.new
            options.add_argument('--disable-infobars')
            options.add_argument("--user-agent='#{user_agent}'")
            options.add_argument("--lang=#{ENV['LOCALE']}") if ENV['LOCALE']
            Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
          end
        end
      end
      Capybara.default_driver = :selenium
    end

    def self.initialize_browserstack
      browser = ENV['BS_BROWSER']

      if ENV['BS_REAL_MOBILE'] || ENV['BS_PLATFORM']
        Environ.platform    = :mobile
        Environ.device_name = ENV['BS_DEVICE']
        Environ.device_os   = ENV['BS_OS']
        Environ.device_orientation = ENV['ORIENTATION'] if ENV['ORIENTATION']
      elsif ENV['BS_OS']
        Environ.os = "#{ENV['BS_OS']} #{ENV['BS_OS_VERSION']}"
      end

      endpoint = "http://#{ENV['BS_USERNAME']}:#{ENV['BS_AUTHKEY']}@hub-cloud.browserstack.com/wd/hub"
      Capybara.register_driver :browserstack do |app|
        capabilities = Selenium::WebDriver::Remote::Capabilities.new

        if ENV['BS_REAL_MOBILE']
          Environ.device = :device
          capabilities['device'] = ENV['BS_DEVICE']
          capabilities['realMobile'] = true
          capabilities['os_version'] = ENV['BS_OS_VERSION']

        elsif ENV['BS_PLATFORM']
          Environ.device = :simulator
          capabilities[:platform] = ENV['BS_PLATFORM']
          capabilities[:browserName] = browser
          capabilities['device'] = ENV['BS_DEVICE'] if ENV['BS_DEVICE']
          capabilities['deviceOrientation'] = ENV['ORIENTATION'] if ENV['ORIENTATION']

        elsif ENV['BS_OS']
          capabilities['os'] = ENV['BS_OS']
          capabilities['os_version'] = ENV['BS_OS_VERSION']
          capabilities['browser'] = browser || 'chrome'
          capabilities['browser_version'] = ENV['BS_VERSION'] if ENV['BS_VERSION']
          capabilities['resolution'] = ENV['RESOLUTION'] if ENV['RESOLUTION']
        end

        capabilities['browserstack.selenium_version'] = ENV['SELENIUM_VERSION'] if ENV['SELENIUM_VERSION']
        capabilities['browserstack.console'] = ENV['CONSOLE_LOGS'] if ENV['CONSOLE_LOGS']
        capabilities['browserstack.timezone'] = ENV['TIME_ZONE'] if ENV['TIME_ZONE']
        capabilities['browserstack.video'] = ENV['RECORD_VIDEO'] if ENV['RECORD_VIDEO']
        capabilities['browserstack.debug'] = 'true'
        capabilities['project'] = ENV['AUTOMATE_PROJECT'] if ENV['AUTOMATE_PROJECT']
        capabilities['build'] = ENV['AUTOMATE_BUILD'] if ENV['AUTOMATE_BUILD']

        ENV['TEST_CONTEXT'] ?
            context_message = "#{Environ.test_environment} - #{ENV['TEST_CONTEXT']}" :
            context_message = Environ.test_environment
        if ENV['PARALLEL']
          thread_num = ENV['TEST_ENV_NUMBER']
          thread_num = 1 if thread_num.blank?
          context_message = "#{context_message} - Thread ##{thread_num}"
        end
        capabilities['name'] = context_message

        capabilities['acceptSslCerts'] = 'true'
        capabilities['browserstack.localIdentifier'] = ENV['BS_LOCAL_ID'] if ENV['BS_LOCAL_ID']
        capabilities['browserstack.local'] = 'true' if ENV['TUNNELING']

        case browser.downcase.to_sym
        when :ie
          capabilities['ie.ensureCleanSession'] = 'true'
          capabilities['ie.browserCommandLineSwitches'] = 'true'
          capabilities['nativeEvents'] = 'true'
          capabilities['browserstack.ie.driver'] = ENV['WD_VERSION'] if ENV['WD_VERSION']
        when :firefox
          capabilities['browserstack.geckodriver'] = ENV['WD_VERSION'] if ENV['WD_VERSION']
        when :safari
          capabilities['cleanSession'] = 'true'
          capabilities['browserstack.safari.driver'] = ENV['WD_VERSION'] if ENV['WD_VERSION']
        when :iphone, :ipad
          capabilities['javascriptEnabled'] = 'true'
          capabilities['cleanSession'] = 'true'
        end

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

        Capybara::Selenium::Driver.new(app, browser: :remote, url: endpoint, desired_capabilities: capabilities)
      end

      Environ.browser = browser
      Environ.tunneling = ENV['TUNNELING'] if ENV['TUNNELING']
      Environ.device_type = ENV['DEVICE_TYPE'] if ENV['DEVICE_TYPE']

      Capybara.default_driver = :browserstack
      Capybara.run_server = false
    end

    def self.initialize_crossbrowser
      browser = ENV['CB_BROWSER']

      if ENV['CB_OS']
        Environ.os = ENV['CB_OS']
        Environ.platform = :desktop
      elsif ENV['CB_PLATFORM']
        Environ.device_name = ENV['CB_PLATFORM']
        Environ.device      = :device
        Environ.platform    = :mobile
        Environ.device_type = ENV['DEVICE_TYPE'] if ENV['DEVICE_TYPE']
      end

      endpoint = "http://#{ENV['CB_USERNAME']}:#{ENV['CB_AUTHKEY']}@hub.crossbrowsertesting.com:80/wd/hub"
      Capybara.register_driver :crossbrowser do |app|
        capabilities = Selenium::WebDriver::Remote::Capabilities.new
        capabilities['name'] = ENV['AUTOMATE_PROJECT'] if ENV['AUTOMATE_PROJECT']
        capabilities['build'] = ENV['AUTOMATE_BUILD'] if ENV['AUTOMATE_BUILD']
        capabilities['browser_api_name'] = browser
        capabilities['screen_resolution'] = ENV['RESOLUTION'] if ENV['RESOLUTION']
        if ENV['CB_OS']
          capabilities['os_api_name'] = ENV['CB_OS']
          Environ.platform = :desktop
        elsif ENV['CB_PLATFORM']
          capabilities['os_api_name'] = ENV['CB_PLATFORM']
        end
        Capybara::Selenium::Driver.new(app, browser: :remote, url: endpoint, desired_capabilities: capabilities)
      end

      Environ.browser = browser

      Capybara.default_driver = :crossbrowser
      Capybara.run_server = false
    end

    def self.initialize_gridlastic
      browser = ENV['GL_BROWSER']
      Environ.os = ENV['GL_OS']
      endpoint = "http://#{ENV['GL_USERNAME']}:#{ENV['GL_AUTHKEY']}@#{ENV['GL_SUBDOMAIN']}.gridlastic.com:80/wd/hub"

      capabilities = Selenium::WebDriver::Remote::Capabilities.new
      capabilities['browserName']  = browser
      capabilities['version']      = ENV['GL_VERSION'] if ENV['GL_VERSION']
      capabilities['platform']     = ENV['GL_OS']
      capabilities['platformName'] = ENV['GL_PLATFORM']
      capabilities['video']        = ENV['RECORD_VIDEO'].capitalize if ENV['RECORD_VIDEO']

      Capybara.register_driver :selenium do |app|
        client = Selenium::WebDriver::Remote::Http::Default.new
        client.timeout = 1200
        Capybara::Selenium::Driver.new(app, http_client: client, browser: :remote, url: endpoint, desired_capabilities: capabilities)
      end

      Capybara.default_driver = :selenium
      Capybara.run_server = false

      if ENV['RECORD_VIDEO']
        session_id = Capybara.current_session.driver.browser.instance_variable_get(:@bridge).session_id
        puts "TEST VIDEO URL: #{ENV['VIDEO_URL']}#{session_id}"
      end
    end

    def self.initialize_remote
      browser = ENV['WEB_BROWSER']
      endpoint = ENV['REMOTE_ENDPOINT'] || 'http://127.0.0.1:4444/wd/hub'
      capabilities = Selenium::WebDriver::Remote::Capabilities.send(browser.downcase.to_sym)
      Capybara.register_driver :remote_browser do |app|
        Capybara::Selenium::Driver.new(app, browser: :remote, url: endpoint, desired_capabilities: capabilities)
      end
      Capybara.current_driver = :remote_browser
      Capybara.default_driver = :remote_browser
    end

    def self.initialize_saucelabs
      browser = ENV['SL_BROWSER']

      if ENV['SL_OS']
        Environ.platform = :desktop
        Environ.os = ENV['SL_OS']
      elsif ENV['SL_PLATFORM']
        Environ.device_name = ENV['SL_DEVICE']
        Environ.platform    = :mobile
      end

      endpoint = "http://#{ENV['SL_USERNAME']}:#{ENV['SL_AUTHKEY']}@ondemand.saucelabs.com:80/wd/hub"
      Capybara.register_driver :saucelabs do |app|
        capabilities = Selenium::WebDriver::Remote::Capabilities.new
        capabilities['name'] = ENV['AUTOMATE_PROJECT'] if ENV['AUTOMATE_PROJECT']
        capabilities['build'] = ENV['AUTOMATE_BUILD'] if ENV['AUTOMATE_BUILD']
        capabilities['browserName'] = browser
        capabilities['version'] = ENV['SL_VERSION'] if ENV['SL_VERSION']
        capabilities['screenResolution'] = ENV['RESOLUTION'] if ENV['RESOLUTION']
        capabilities['recordVideo'] = ENV['RECORD_VIDEO'] if ENV['RECORD_VIDEO']
        if ENV['SL_OS']
          capabilities['platform'] = ENV['SL_OS']
        elsif ENV['SL_PLATFORM']
          capabilities['platform'] = ENV['SL_PLATFORM']
          capabilities['deviceName'] = ENV['SL_DEVICE']
          capabilities['deviceType'] = ENV['SL_DEVICE_TYPE'] if ENV['SL_DEVICE_TYPE']
          capabilities['deviceOrientation'] = ENV['ORIENTATION'] if ENV['ORIENTATION']
        end

        Capybara::Selenium::Driver.new(app, browser: :remote, url: endpoint, desired_capabilities: capabilities)
      end

      Environ.browser = browser

      Capybara.default_driver = :saucelabs
      Capybara.run_server = false
    end

    def self.initialize_testingbot
      browser = ENV['TB_BROWSER']

      Environ.os = ENV['TB_OS']
      if ENV['TB_PLATFORM']
        Environ.device_orientation = ENV['ORIENTATION'] if ENV['ORIENTATION']
        Environ.device_os   = ENV['TB_PLATFORM']
        Environ.device_name = ENV['TB_DEVICE']
        Environ.device      = :device
        Environ.platform    = :mobile
        Environ.device_type = ENV['DEVICE_TYPE'] if ENV['DEVICE_TYPE']
      else
        Environ.platform = :desktop
      end

      ENV['TUNNELING'] ?
          endpoint = '@localhost:4445/wd/hub' :
          endpoint = '@hub.testingbot.com:4444/wd/hub'
      endpoint = "http://#{ENV['TB_USERNAME']}:#{ENV['TB_AUTHKEY']}#{endpoint}"
      Capybara.register_driver :testingbot do |app|
        capabilities = Selenium::WebDriver::Remote::Capabilities.new
        capabilities['name'] = ENV['AUTOMATE_PROJECT'] if ENV['AUTOMATE_PROJECT']
        capabilities['build'] = ENV['AUTOMATE_BUILD'] if ENV['AUTOMATE_BUILD']
        capabilities['browserName'] = browser
        capabilities['version'] = ENV['TB_VERSION'] if ENV['TB_VERSION']
        capabilities['screen-resolution'] = ENV['RESOLUTION'] if ENV['RESOLUTION']
        capabilities['platform'] = ENV['TB_OS']
        capabilities['record_video'] = ENV['RECORD_VIDEO'] if ENV['RECORD_VIDEO']
        if ENV['TB_PLATFORM']
          capabilities['orientation']  = ENV['ORIENTATION'] if ENV['ORIENTATION']
          capabilities['platformName'] = ENV['TB_PLATFORM']
          capabilities['deviceName']   = ENV['TB_DEVICE']
        end

        Capybara::Selenium::Driver.new(app, browser: :remote, url: endpoint, desired_capabilities: capabilities)
      end

      Environ.browser = browser

      Capybara.default_driver = :testingbot
      Capybara.run_server = false
    end
  end
end
