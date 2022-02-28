require 'selenium-webdriver'
require 'os'
require 'browserstack/local'
require 'webdrivers'
require 'fileutils'


module TestCentricity
  class WebDriverConnect
    include Capybara::DSL

    attr_accessor :bs_local
    attr_accessor :downloads_path

    def self.initialize_web_driver(options = nil)
      desired_caps = nil
      if options.is_a?(String)
        Capybara.app_host = options
      elsif options.is_a?(Hash)
        Capybara.app_host = options[:app_host] if options.key?(:app_host)
        desired_caps = options[:desired_capabilities] if options.key?(:desired_capabilities)
      end

      browser = ENV['WEB_BROWSER']
      # set downloads folder path
      @downloads_path = "#{Dir.pwd}/downloads"
      if ENV['PARALLEL']
        Environ.parallel = true
        Environ.process_num = ENV['TEST_ENV_NUMBER']
        @downloads_path = "#{@downloads_path}/#{ENV['TEST_ENV_NUMBER']}"
        Dir.mkdir(@downloads_path) unless Dir.exist?(@downloads_path)
      else
        Environ.parallel = false
      end
      @downloads_path = @downloads_path.tr('/', "\\") if OS.windows?

      # assume that we're testing within a local desktop web browser
      Environ.driver      = :webdriver
      Environ.platform    = :desktop
      Environ.browser     = browser
      Environ.headless    = false
      Environ.device      = :web
      Environ.device_name = 'browser'

      context = case browser.downcase.to_sym
                when :appium
                  initialize_appium(desired_caps)
                  'mobile device emulator'
                when :browserstack
                  initialize_browserstack(desired_caps)
                  'Browserstack cloud service'
                when :crossbrowser
                  initialize_crossbrowser(desired_caps)
                  'CrossBrowserTesting cloud service'
                when :gridlastic
                  initialize_gridlastic(desired_caps)
                  'Gridlastic cloud service'
                when :lambdatest
                  initialize_lambdatest(desired_caps)
                  'LambdaTest cloud service'
                when :saucelabs
                  initialize_saucelabs(desired_caps)
                  'Sauce Labs cloud service'
                when :testingbot
                  initialize_testingbot(desired_caps)
                  'TestingBot cloud service'
                else
                  if ENV['SELENIUM'] == 'remote'
                    initialize_remote
                    'Selenium Grid'
                  else
                    initialize_local_browser
                    'local browser instance'
                  end
                end

      # set browser window size only if testing with a desktop web browser
      unless Environ.is_device? || Capybara.current_driver == :appium
        initialize_browser_size
      end

      # set Capybara's server port if PARALLEL_PORT is true
      Capybara.server_port = 9887 + ENV['TEST_ENV_NUMBER'].to_i if ENV['PARALLEL'] && ENV['PARALLEL_PORT']

      Environ.session_state = :running
      puts "Using #{Environ.browser} browser via #{context}"
    end

    def self.set_domain(url)
      Capybara.app_host = url
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

    def self.initialize_appium(desired_caps = nil)
      Environ.platform    = :mobile
      Environ.device_name = ENV['APP_DEVICE']
      Environ.device_os   = ENV['APP_PLATFORM_NAME'].downcase.to_sym
      Environ.device_type = ENV['DEVICE_TYPE'] if ENV['DEVICE_TYPE']
      Environ.device_os_version = ENV['APP_VERSION']
      Environ.device_orientation = ENV['ORIENTATION'] if ENV['ORIENTATION']
      Capybara.default_driver = :appium
      endpoint = 'http://localhost:4723/wd/hub'
      desired_capabilities = {
          platformName:    Environ.device_os,
          platformVersion: Environ.device_os_version,
          browserName:     ENV['APP_BROWSER'],
          deviceName:      Environ.device_name
      }
      desired_capabilities[:avd] = ENV['APP_DEVICE'] if Environ.device_os == :android
      desired_capabilities[:automationName] = ENV['AUTOMATION_ENGINE'] if ENV['AUTOMATION_ENGINE']
      if ENV['UDID']
        Environ.device = :device
        desired_capabilities[:udid] = ENV['UDID']
        desired_capabilities[:xcodeOrgId] = ENV['TEAM_ID'] if ENV['TEAM_ID']
        desired_capabilities[:xcodeSigningId] = ENV['TEAM_NAME'] if ENV['TEAM_NAME']
      else
        Environ.device = :simulator
        desired_capabilities[:orientation] = Environ.device_orientation.upcase if Environ.device_orientation
        if Environ.device_os == :ios
          desired_capabilities[:language] = Environ.language if Environ.language
          desired_capabilities[:locale] = Environ.locale.gsub('-', '_') if Environ.locale
        end
      end
      desired_capabilities[:safariIgnoreFraudWarning] = ENV['APP_IGNORE_FRAUD_WARNING'] if ENV['APP_IGNORE_FRAUD_WARNING']
      desired_capabilities[:safariInitialUrl] = ENV['APP_INITIAL_URL'] if ENV['APP_INITIAL_URL']
      desired_capabilities[:safariAllowPopups] = ENV['APP_ALLOW_POPUPS'] if ENV['APP_ALLOW_POPUPS']
      desired_capabilities[:shutdownOtherSimulators] = ENV['SHUTDOWN_OTHER_SIMS'] if ENV['SHUTDOWN_OTHER_SIMS']
      desired_capabilities[:forceSimulatorSoftwareKeyboardPresence] = ENV['SHOW_SIM_KEYBOARD'] if ENV['SHOW_SIM_KEYBOARD']

      desired_capabilities[:autoAcceptAlerts] = ENV['AUTO_ACCEPT_ALERTS'] if ENV['AUTO_ACCEPT_ALERTS']
      desired_capabilities[:autoDismissAlerts] = ENV['AUTO_DISMISS_ALERTS'] if ENV['AUTO_DISMISS_ALERTS']
      desired_capabilities[:isHeadless] = ENV['HEADLESS'] if ENV['HEADLESS']

      desired_capabilities[:newCommandTimeout] = ENV['NEW_COMMAND_TIMEOUT'] if ENV['NEW_COMMAND_TIMEOUT']
      desired_capabilities[:noReset] = ENV['APP_NO_RESET'] if ENV['APP_NO_RESET']
      desired_capabilities[:fullReset] = ENV['APP_FULL_RESET'] if ENV['APP_FULL_RESET']
      desired_capabilities[:webkitDebugProxyPort] = ENV['WEBKIT_DEBUG_PROXY_PORT'] if ENV['WEBKIT_DEBUG_PROXY_PORT']
      desired_capabilities[:webDriverAgentUrl] = ENV['WEBDRIVER_AGENT_URL'] if ENV['WEBDRIVER_AGENT_URL']
      desired_capabilities[:usePrebuiltWDA] = ENV['USE_PREBUILT_WDA'] if ENV['USE_PREBUILT_WDA']
      desired_capabilities[:useNewWDA] = ENV['USE_NEW_WDA'] if ENV['USE_NEW_WDA']
      desired_capabilities[:chromedriverExecutable] = ENV['CHROMEDRIVER_EXECUTABLE'] if ENV['CHROMEDRIVER_EXECUTABLE']
      # set wdaLocalPort (iOS) or systemPort (Android) if PARALLEL_PORT is true
      if ENV['PARALLEL'] && ENV['PARALLEL_PORT']
        if Environ.device_os == :ios
          desired_capabilities[:wdaLocalPort] = 8100 + ENV['TEST_ENV_NUMBER'].to_i
        else
          desired_capabilities[:systemPort] = 8200 + ENV['TEST_ENV_NUMBER'].to_i
        end
      else
        desired_capabilities[:wdaLocalPort] = ENV['WDA_LOCAL_PORT'] if ENV['WDA_LOCAL_PORT']
        desired_capabilities[:systemPort]   = ENV['SYSTEM_PORT'] if ENV['SYSTEM_PORT']
      end

      unless desired_caps.nil?
        desired_capabilities = desired_caps
      end

      Capybara.register_driver :appium do |app|
        appium_lib_options = { server_url: endpoint }
        all_options = {
          appium_lib: appium_lib_options,
          caps:       desired_capabilities
        }
        Appium::Capybara::Driver.new(app, all_options)
      end
    end

    def self.initialize_local_browser
      Environ.os = case
                   when OS.osx?
                     'OS X'
                   when OS.windows?
                     'Windows'
                   when OS.linux?
                     'Linux'
                   else
                     'unknown'
                   end
      browser = ENV['WEB_BROWSER'].downcase.to_sym

      case browser
      when :firefox, :chrome, :ie, :safari, :edge
        Environ.platform = :desktop
      when :chrome_headless, :firefox_headless, :edge_headless
        Environ.platform = :desktop
        Environ.headless = true
      else
        Environ.platform = :mobile
        Environ.device_name = Browsers.mobile_device_name(ENV['WEB_BROWSER'])
      end

      Capybara.register_driver :selenium do |app|
        case browser
        when :safari
          Capybara::Selenium::Driver.new(app, browser: browser)
        when :ie
          Capybara::Selenium::Driver.new(app, browser: browser)
        when :firefox, :firefox_headless
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
          options.args << '--headless' if browser == :firefox_headless
          Capybara::Selenium::Driver.new(app, browser: :firefox, capabilities: [options])
        when :chrome, :chrome_headless
          options = Selenium::WebDriver::Chrome::Options.new(options: {'excludeSwitches' => ['enable-automation']})
          prefs = {
            prompt_for_download: false,
            directory_upgrade:   true,
            default_directory:   @downloads_path
          }
          options.add_preference(:download, prefs)
          options.add_argument('--disable-dev-shm-usage')
          options.add_argument("--lang=#{ENV['LOCALE']}") if ENV['LOCALE']
          if browser == :chrome_headless
            options.add_argument('--headless')
            options.add_argument('--disable-gpu')
            options.add_argument('--no-sandbox')
          end

          Capybara::Selenium::Driver.new(app, browser: :chrome, capabilities: [options])
        when :edge, :edge_headless
          options = Selenium::WebDriver::Edge::Options.new(options: {'excludeSwitches' => ['enable-automation']})
          prefs = {
            prompt_for_download: false,
            directory_upgrade:   true,
            default_directory:   @downloads_path
          }
          options.add_preference(:download, prefs)
          options.add_argument('--disable-dev-shm-usage')
          options.add_argument("--lang=#{ENV['LOCALE']}") if ENV['LOCALE']
          if browser == :edge_headless
            options.add_argument('--headless')
            options.add_argument('--disable-gpu')
            options.add_argument('--no-sandbox')
          end

          Capybara::Selenium::Driver.new(app, browser: :edge, capabilities: [options])
        else
          if ENV['HOST_BROWSER'] && ENV['HOST_BROWSER'].downcase.to_sym == :chrome
            user_agent = Browsers.mobile_device_agent(ENV['WEB_BROWSER'])
            options = Selenium::WebDriver::Chrome::Options.new
            options.add_argument('--disable-infobars')
            options.add_argument('--disable-dev-shm-usage')
            options.add_argument("--user-agent='#{user_agent}'")
            options.add_argument("--lang=#{ENV['LOCALE']}") if ENV['LOCALE']
            Capybara::Selenium::Driver.new(app, browser: :chrome, capabilities: [options])
          else
            raise "Requested browser '#{browser}' is not supported"
          end
        end
      end
      Capybara.default_driver = :selenium
    end

    def self.initialize_browserstack(desired_caps = nil)
      browser = ENV['BS_BROWSER']
      Environ.grid = :browserstack

      if ENV['BS_REAL_MOBILE'] || ENV['BS_DEVICE']
        Environ.platform    = :mobile
        Environ.device_name = ENV['BS_DEVICE']
        Environ.device_os   = ENV['BS_OS']
        Environ.device_orientation = ENV['ORIENTATION'] if ENV['ORIENTATION']
        Environ.device = if ENV['BS_REAL_MOBILE']
                           :device
                         else
                           :simulator
                         end
      elsif ENV['BS_OS']
        Environ.os = "#{ENV['BS_OS']} #{ENV['BS_OS_VERSION']}"
      end
      # specify endpoint url
      endpoint = "http://#{ENV['BS_USERNAME']}:#{ENV['BS_AUTHKEY']}@hub-cloud.browserstack.com/wd/hub"
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
      # define BrowserStack options
      options = if desired_caps.nil?
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
                  if ENV['BS_DEVICE']
                    bs_options[:deviceName] = ENV['BS_DEVICE']
                    bs_options[:appiumVersion] = '1.22.0'
                    {
                      browserName: browser,
                      'bstack:options': bs_options
                    }
                  else
                    bs_options[:resolution] = ENV['RESOLUTION'] if ENV['RESOLUTION']
                    bs_options[:seleniumVersion] = '4.1.0'
                    {
                      browserName: browser,
                      browserVersion: ENV['BS_VERSION'],
                      'bstack:options': bs_options
                    }
                  end
                else
                  desired_caps
                end
      Capybara.register_driver :browserstack do |app|
        capabilities = Selenium::WebDriver::Remote::Capabilities.send(browser.gsub(/\s+/, '_').downcase.to_sym, options)
        Capybara::Selenium::Driver.new(app, browser: :remote, url: endpoint, capabilities: capabilities)
      end

      Environ.browser = browser
      Environ.tunneling = ENV['TUNNELING'] if ENV['TUNNELING']
      Environ.device_type = ENV['DEVICE_TYPE'] if ENV['DEVICE_TYPE']

      Capybara.default_driver = :browserstack
      Capybara.run_server = false
      # configure file_detector for remote uploads
      selenium = Capybara.page.driver.browser
      selenium.file_detector = lambda do |args|
        str = args.first.to_s
        str if File.exist?(str)
      end
    end

    def self.initialize_crossbrowser(desired_caps = nil)
      browser = ENV['CB_BROWSER']
      Environ.grid = :crossbrowser

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

        unless desired_caps.nil?
          capabilities = desired_caps
        end

        Capybara::Selenium::Driver.new(app, browser: :remote, url: endpoint, desired_capabilities: capabilities)
      end

      Environ.browser = browser

      Capybara.default_driver = :crossbrowser
      Capybara.run_server = false
      # configure file_detector for remote uploads
      selenium = Capybara.page.driver.browser
      selenium.file_detector = lambda do |args|
        str = args.first.to_s
        str if File.exist?(str)
      end
    end

    def self.initialize_gridlastic(desired_caps = nil)
      browser = ENV['GL_BROWSER']
      Environ.grid = :gridlastic
      Environ.os = ENV['GL_OS']
      endpoint = "http://#{ENV['GL_USERNAME']}:#{ENV['GL_AUTHKEY']}@#{ENV['GL_SUBDOMAIN']}.gridlastic.com:80/wd/hub"
      capabilities = Selenium::WebDriver::Remote::Capabilities.new
      capabilities['browserName']  = browser
      capabilities['version']      = ENV['GL_VERSION'] if ENV['GL_VERSION']
      capabilities['platform']     = ENV['GL_OS']
      capabilities['platformName'] = ENV['GL_PLATFORM']
      capabilities['video']        = ENV['RECORD_VIDEO'].capitalize if ENV['RECORD_VIDEO']

      unless desired_caps.nil?
        capabilities = desired_caps
      end

      Capybara.register_driver :selenium do |app|
        client = Selenium::WebDriver::Remote::Http::Default.new
        client.timeout = 1200
        Capybara::Selenium::Driver.new(app, http_client: client, browser: :remote, url: endpoint, desired_capabilities: capabilities)
      end

      Environ.browser = browser

      Capybara.default_driver = :selenium
      Capybara.run_server = false

      if ENV['RECORD_VIDEO']
        session_id = Capybara.current_session.driver.browser.instance_variable_get(:@bridge).session_id
        puts "TEST VIDEO URL: #{ENV['VIDEO_URL']}#{session_id}"
      end
      # configure file_detector for remote uploads
      selenium = Capybara.page.driver.browser
      selenium.file_detector = lambda do |args|
        str = args.first.to_s
        str if File.exist?(str)
      end
    end

    def self.initialize_lambdatest(desired_caps = nil)
      browser = ENV['LT_BROWSER']
      Environ.grid = :lambdatest
      Environ.os = ENV['LT_OS']
      Environ.platform = :desktop
      Environ.tunneling = ENV['TUNNELING'] if ENV['TUNNELING']
      # specify endpoint url
      endpoint = "https://#{ENV['LT_USERNAME']}:#{ENV['LT_AUTHKEY']}@hub.lambdatest.com/wd/hub"
      # define LambdaTest options
      options = if desired_caps.nil?
                  # define the required set of LambdaTest options
                  lt_options = {
                    user: ENV['LT_USERNAME'],
                    accessKey: ENV['LT_AUTHKEY'],
                    build: test_context_message,
                    platformName: ENV['LT_OS'],
                    resolution: ENV['RESOLUTION'],
                    selenium_version: '4.0.0',
                  }
                  # define the optional LambdaTest options
                  lt_options[:name] = ENV['AUTOMATE_PROJECT'] if ENV['AUTOMATE_PROJECT']
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
                  desired_caps
                end
      Capybara.register_driver :lambdatest do |app|
        capabilities = Selenium::WebDriver::Remote::Capabilities.send(browser.gsub(/\s+/, '_').downcase.to_sym, options)
        Capybara::Selenium::Driver.new(app, browser: :remote, url: endpoint, capabilities: capabilities)
      end

      Environ.browser = browser

      Capybara.default_driver = :lambdatest
      Capybara.run_server = false
      # configure file_detector for remote uploads
      selenium = Capybara.page.driver.browser
      selenium.file_detector = lambda do |args|
        str = args.first.to_s
        str if File.exist?(str)
      end
    end

    def self.initialize_remote
      Environ.grid = :selenium_grid
      browser  = ENV['WEB_BROWSER'].downcase.to_sym
      endpoint = ENV['REMOTE_ENDPOINT'] || 'http://127.0.0.1:4444/wd/hub'
      Capybara.register_driver :remote_browser do |app|
        case browser
        when :firefox, :safari, :ie, :edge
          capabilities = Selenium::WebDriver::Remote::Capabilities.send(browser)
        when :chrome, :chrome_headless
          options = %w[--disable-infobars]
          options.push('--disable-dev-shm-usage')
          options.push("--lang=#{ENV['LOCALE']}") if ENV['LOCALE']
          if browser == :chrome_headless
            Environ.headless = true
            options.push('--headless')
            options.push('--disable-gpu')
            options.push('--no-sandbox')
          end
          capabilities = Selenium::WebDriver::Remote::Capabilities.chrome('goog:chromeOptions' => { args: options })
        else
          if ENV['HOST_BROWSER'] && ENV['HOST_BROWSER'].downcase.to_sym == :chrome
            Environ.platform = :mobile
            Environ.device_name = Browsers.mobile_device_name(ENV['WEB_BROWSER'])
            user_agent = Browsers.mobile_device_agent(ENV['WEB_BROWSER'])
            options = %w[--disable-infobars]
            options.push('--disable-dev-shm-usage')
            options.push("--user-agent='#{user_agent}'")
            options.push("--lang=#{ENV['LOCALE']}") if ENV['LOCALE']
            capabilities = Selenium::WebDriver::Remote::Capabilities.chrome('goog:chromeOptions' => { args: options })
          else
            raise "Requested browser '#{browser}' is not supported on Selenium Grid"
          end
        end
        Capybara::Selenium::Driver.new(app,
                                       browser: :remote,
                                       url: endpoint,
                                       desired_capabilities: capabilities).tap do |driver|
          # configure file_detector for remote uploads
          driver.browser.file_detector = lambda do |args|
            str = args.first.to_s
            str if File.exist?(str)
          end
        end
      end
      Capybara.current_driver = :remote_browser
      Capybara.default_driver = :remote_browser
    end

    def self.initialize_saucelabs(desired_caps = nil)
      browser = ENV['SL_BROWSER']
      Environ.grid = :saucelabs

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

        unless desired_caps.nil?
          capabilities = desired_caps
        end

        Capybara::Selenium::Driver.new(app, browser: :remote, url: endpoint, desired_capabilities: capabilities)
      end

      Environ.browser = browser

      Capybara.default_driver = :saucelabs
      Capybara.run_server = false
      # configure file_detector for remote uploads
      selenium = Capybara.page.driver.browser
      selenium.file_detector = lambda do |args|
        str = args.first.to_s
        str if File.exist?(str)
      end
    end

    def self.initialize_testingbot(desired_caps = nil)
      browser = ENV['TB_BROWSER']
      Environ.grid = :testingbot

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

      endpoint = ENV['TUNNELING'] ? '@localhost:4445/wd/hub' : '@hub.testingbot.com:4444/wd/hub'
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

        unless desired_caps.nil?
          capabilities = desired_caps
        end

        Capybara::Selenium::Driver.new(app, browser: :remote, url: endpoint, desired_capabilities: capabilities)
      end

      Environ.browser = browser

      Capybara.default_driver = :testingbot
      Capybara.run_server = false
      # configure file_detector for remote uploads
      selenium = Capybara.page.driver.browser
      selenium.file_detector = lambda do |args|
        str = args.first.to_s
        str if File.exist?(str)
      end
    end

    def self.test_context_message
      context_message = if ENV['TEST_CONTEXT']
                          "#{Environ.test_environment.to_s.upcase} - #{ENV['TEST_CONTEXT']}"
                        else
                          Environ.test_environment.to_s.upcase
                        end
      if ENV['PARALLEL']
        thread_num = ENV['TEST_ENV_NUMBER']
        thread_num = 1 if thread_num.blank?
        context_message = "#{context_message} - Thread ##{thread_num}"
      end
      context_message
    end
  end
end
