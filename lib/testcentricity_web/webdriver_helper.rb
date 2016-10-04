require 'selenium-webdriver'


module TestCentricity
  module WebDriverConnect
    include Capybara::DSL

    def self.initialize_web_driver(app_host = nil)
      Capybara.app_host = app_host unless app_host.nil?
      browser = ENV['WEB_BROWSER']

      # assume that we're testing within a local desktop web browser
      Environ.set_platform(:desktop)
      Environ.set_browser(browser)
      Environ.set_device(false)
      Environ.set_device_type('browser')

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
        when :poltergeist
          initialize_poltergeist
          context = 'PhantomJS'
        when :saucelabs
          initialize_saucelabs
          context = 'Sauce Labs cloud service'
        when :testingbot
          initialize_testingbot
          context = 'TestingBot cloud service'
        else
          if ENV["SELENIUM"] == 'remote'
            initialize_remote
            context = 'Selenium Grid2'
          else
            initialize_local_browser
            context = 'local instance'
          end
      end

      # set browser window size only if testing with a desktop web browser
      initialize_browser_size unless Capybara.current_driver == :poltergeist || Capybara.current_driver == :appium

      puts "Using #{Environ.browser.to_s} browser via #{context}"
    end

    def self.set_domain(url)
      Capybara.app_host = url
    end

    private

    def self.initialize_appium
      Environ.set_device(true)
      Environ.set_platform(:mobile)
      Environ.set_device_type(ENV['APP_DEVICE'])
      Capybara.default_driver = :appium
      endpoint = 'http://localhost:4723/wd/hub'
      desired_capabilities = {
          platformName:    ENV['APP_PLATFORM_NAME'],
          platformVersion: ENV['APP_VERSION'],
          browserName:     ENV['APP_BROWSER'],
          deviceName:      ENV['APP_DEVICE']
      }
      desired_capabilities['avd'] = ENV['APP_DEVICE'] if ENV['APP_PLATFORM_NAME'].downcase.to_sym == :android
      desired_capabilities['orientation'] = ENV['ORIENTATION'].upcase if ENV['ORIENTATION']
      desired_capabilities['udid'] = ENV['APP_UDID'] if ENV['APP_UDID']
      desired_capabilities['safariInitialUrl'] = ENV['APP_INITIAL_URL'] if ENV['APP_INITIAL_URL']
      desired_capabilities['safariAllowPopups'] = ENV['APP_ALLOW_POPUPS'] if ENV['APP_ALLOW_POPUPS']
      desired_capabilities['safariIgnoreFraudWarning'] = ENV['APP_IGNORE_FRAUD_WARNING'] if ENV['APP_IGNORE_FRAUD_WARNING']
      desired_capabilities['noReset'] = ENV['APP_NO_RESET'] if ENV['APP_NO_RESET']
      desired_capabilities['locale'] = ENV['LOCALE'] if ENV['LOCALE']

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
      browser = ENV['WEB_BROWSER']
      Capybara.default_driver = :selenium
      Capybara.register_driver :selenium do |app|
        case browser.downcase.to_sym
        when :firefox, :chrome, :ie, :safari, :edge
          Capybara::Selenium::Driver.new(app, :browser => browser.to_sym)
        else
          user_agent = Browsers.mobile_device_agent(browser)
          Environ.set_platform(:mobile)
          Environ.set_device_type(Browsers.mobile_device_name(browser))
          ENV['HOST_BROWSER'] ? host_browser = ENV['HOST_BROWSER'].downcase.to_sym : host_browser = :firefox
          case host_browser
          when :firefox
            profile = Selenium::WebDriver::Firefox::Profile.new
            profile['general.useragent.override'] = user_agent
            Capybara::Selenium::Driver.new(app, :profile => profile)
          when :chrome
            args = []
            args << "--user-agent='#{user_agent}'"
            Capybara::Selenium::Driver.new(app, :browser => :chrome, :args => args)
          end
        end
      end
    end

    def self.initialize_browserstack
      browser = ENV['BS_BROWSER']

      endpoint = "http://#{ENV['BS_USERNAME']}:#{ENV['BS_AUTHKEY']}@hub.browserstack.com/wd/hub"
      Capybara.register_driver :browserstack do |app|
        capabilities = Selenium::WebDriver::Remote::Capabilities.new

        if ENV['BS_OS']
          capabilities['os'] = ENV['BS_OS']
          capabilities['os_version'] = ENV['BS_OS_VERSION']
          Environ.set_os("#{ENV['BS_OS']} #{ENV['BS_OS_VERSION']}")
          capabilities['browser'] = browser || 'chrome'
          capabilities['browser_version'] = ENV['BS_VERSION'] if ENV['BS_VERSION']
          capabilities['resolution'] = ENV['RESOLUTION'] if ENV['RESOLUTION']
        elsif ENV['BS_PLATFORM']
          capabilities[:platform] = ENV['BS_PLATFORM']
          capabilities[:browserName] = browser
          capabilities['device'] = ENV['BS_DEVICE'] if ENV['BS_DEVICE']
          Environ.set_platform(:mobile)
          Environ.set_device(true)
          Environ.set_device_type(ENV['BS_DEVICE'])
          capabilities['deviceOrientation'] = ENV['ORIENTATION'] if ENV['ORIENTATION']
        end

        capabilities['browserstack.video'] = ENV['RECORD_VIDEO'] if ENV['RECORD_VIDEO']
        capabilities['browserstack.debug'] = 'true'
        capabilities['project'] = ENV['AUTOMATE_PROJECT'] if ENV['AUTOMATE_PROJECT']
        capabilities['build'] = ENV['AUTOMATE_BUILD'] if ENV['AUTOMATE_BUILD']
        ENV['TEST_CONTEXT'] ?
            capabilities['name'] = "#{ENV['TEST_ENVIRONMENT']} - #{ENV['TEST_CONTEXT']}" :
            capabilities['name'] = ENV['TEST_ENVIRONMENT']

        capabilities['acceptSslCerts'] = 'true'
        capabilities['browserstack.localIdentifier'] = ENV['BS_LOCAL_ID'] if ENV['BS_LOCAL_ID']
        capabilities['browserstack.local'] = 'true' if ENV['TUNNELING']

        case browser.downcase.to_sym
        when :ie
          capabilities['ie.ensureCleanSession'] = 'true'
          capabilities['ie.browserCommandLineSwitches'] = 'true'
          capabilities['nativeEvents'] ='true'
        when :safari
          capabilities['cleanSession'] = 'true'
        when :iphone, :ipad
          capabilities['javascriptEnabled'] = 'true'
          capabilities['cleanSession'] = 'true'
        end
        Capybara::Selenium::Driver.new(app, :browser => :remote, :url => endpoint, :desired_capabilities => capabilities)
      end

      Environ.set_browser(browser)

      Capybara.default_driver = :browserstack
      Capybara.run_server = false
    end

    def self.initialize_crossbrowser
      browser = ENV['CB_BROWSER']

      endpoint = "http://#{ENV['CB_USERNAME']}:#{ENV['CB_AUTHKEY']}@hub.crossbrowsertesting.com:80/wd/hub"
      Capybara.register_driver :crossbrowser do |app|
        capabilities = Selenium::WebDriver::Remote::Capabilities.new
        capabilities['name'] = ENV['AUTOMATE_PROJECT'] if ENV['AUTOMATE_PROJECT']
        capabilities['build'] = ENV['AUTOMATE_BUILD'] if ENV['AUTOMATE_BUILD']
        capabilities['browser_api_name'] = browser
        capabilities['screen_resolution'] = ENV['RESOLUTION'] if ENV['RESOLUTION']
        if ENV['CB_OS']
          capabilities['os_api_name'] = ENV['CB_OS']
          Environ.set_platform(:desktop)
        elsif ENV['CB_PLATFORM']
          capabilities['os_api_name'] = ENV['CB_PLATFORM']
          Environ.set_device_type(ENV['CB_PLATFORM'])
          Environ.set_platform(:mobile)
        end
        Capybara::Selenium::Driver.new(app, :browser => :remote, :url => endpoint, :desired_capabilities => capabilities)
      end

      Environ.set_browser(browser)

      Capybara.default_driver = :crossbrowser
      Capybara.run_server = false
    end

    def self.initialize_poltergeist
      if ENV['BROWSER_SIZE']
        resolution = ENV['BROWSER_SIZE'].split(',')
        width  = resolution[0]
        height = resolution[1]
      else
        width  = 1650
        height = 1000
      end
      Capybara.default_driver = :poltergeist
      Capybara.register_driver :poltergeist do |app|
        options = {
            :js_errors => true,
            :timeout => 120,
            :debug => false,
            :phantomjs_options => ['--load-images=no', '--disk-cache=false'],
            :inspector => true,
            :window_size => [width, height]
        }
        Capybara::Poltergeist::Driver.new(app, options)
      end
    end

    def self.initialize_remote
      browser = ENV['WEB_BROWSER']
      endpoint = 'http://127.0.0.1:4444/wd/hub'
      capabilities = Selenium::WebDriver::Remote::Capabilities.send(browser.downcase.to_sym)
      Capybara.register_driver :remote_browser do |app|
        Capybara::Selenium::Driver.new(app, :browser => :remote, :url => endpoint, :desired_capabilities => capabilities)
      end
      Capybara.current_driver = :remote_browser
      Capybara.default_driver = :remote_browser
    end

    def self.initialize_saucelabs
      browser = ENV['SL_BROWSER']

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
          Environ.set_platform(:desktop)
        elsif ENV['SL_PLATFORM']
          capabilities['platform'] = ENV['SL_PLATFORM']
          capabilities['deviceName'] = ENV['SL_DEVICE']
          capabilities['deviceType'] = ENV['SL_DEVICE_TYPE'] if ENV['SL_DEVICE_TYPE']
          capabilities['deviceOrientation'] = ENV['ORIENTATION'] if ENV['ORIENTATION']
          Environ.set_device_type(ENV['SL_DEVICE'])
          Environ.set_platform(:mobile)
        end

        Capybara::Selenium::Driver.new(app, :browser => :remote, :url => endpoint, :desired_capabilities => capabilities)
      end

      Environ.set_browser(browser)

      Capybara.default_driver = :saucelabs
      Capybara.run_server = false
    end

    def self.initialize_testingbot
      browser = ENV['TB_BROWSER']

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
          capabilities['orientation'] = ENV['ORIENTATION'] if ENV['ORIENTATION']
          capabilities['platformName'] = ENV['TB_PLATFORM']
          capabilities['deviceName'] = ENV['TB_DEVICE']
          Environ.set_device_type(ENV['TB_DEVICE'])
          Environ.set_platform(:mobile)
        else
          Environ.set_platform(:desktop)
        end

        Capybara::Selenium::Driver.new(app, :browser => :remote, :url => endpoint, :desired_capabilities => capabilities)
      end

      Environ.set_browser(browser)

      Capybara.default_driver = :testingbot
      Capybara.run_server = false

    end

    def self.initialize_browser_size
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
    end
  end
end
