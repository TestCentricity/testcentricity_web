require 'selenium-webdriver'


module TestCentricity
  class WebDriverConnect
    include Capybara::DSL

    def self.initialize_web_driver(app_host = nil)
      browser = ENV['WEB_BROWSER']

      # assume that we're testing within a local desktop web browser
      Environ.set_platform(:desktop)
      Environ.set_browser(browser)
      Environ.set_device(false)
      Environ.set_device_type('browser')

      case browser.downcase.to_sym
        when :browserstack
          initialize_browserstack
        when :crossbrowser
          initialize_crossbrowser
        when :poltergeist
          initialize_poltergeist
        when :saucelabs
          initialize_saucelabs
        when :testingbot
          initialize_testingbot
        else
          initialize_local_browser(browser)
      end

      Capybara.app_host = app_host unless app_host.nil?

      # set browser window size only if testing with a desktop web browser
      unless Capybara.current_driver == :poltergeist
        if Environ.is_desktop?
          (ENV['BROWSER_SIZE'] == 'max') ?
              Browsers.maximize_browser :
              Browsers.set_browser_window_size(Browsers.browser_size(browser, ENV['ORIENTATION']))
        end
      end

      puts "Using #{Environ.browser.to_s} browser"
    end

    private

    def self.initialize_local_browser(browser)
      Capybara.default_driver = :selenium
      Capybara.register_driver :selenium do |app|
        case browser.downcase.to_sym
          when :firefox, :chrome, :ie, :safari, :edge
            Capybara::Selenium::Driver.new(app, :browser => browser.to_sym)
          when :iphone, :iphone5, :iphone6, :iphone6_plus, :ipad, :ipad_pro, :android_phone, :android_tablet
            Environ.set_platform(:mobile)
            profile = Selenium::WebDriver::Firefox::Profile.new
            profile['general.useragent.override'] = Browsers.mobile_device_agent(browser)
            Capybara::Selenium::Driver.new(app, :profile => profile)
          else
            Capybara::Selenium::Driver.new(app, :browser => :firefox)
            Environ.set_browser('firefox')
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

        capabilities['browserstack.debug'] = 'true'
        capabilities['project'] = ENV['AUTOMATE_PROJECT'] if ENV['AUTOMATE_PROJECT']
        capabilities['build'] = ENV['AUTOMATE_BUILD'] if ENV['AUTOMATE_BUILD']
        ENV['TEST_CONTEXT'] ?
            capabilities['name'] = "#{ENV['TEST_ENVIRONMENT']} - #{ENV['TEST_CONTEXT']}" :
            capabilities['name'] = ENV['TEST_ENVIRONMENT']

        capabilities['acceptSslCerts'] = 'true'
        capabilities['browserstack.local'] = 'true' if ENV['BS_LOCAL']
        capabilities['browserstack.localIdentifier'] =  ENV['BS_LOCAL_ID'] if ENV['BS_LOCAL_ID']

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
          Environ.set_platform(:mobile)
        end
        Capybara::Selenium::Driver.new(app, :browser => :remote, :url => endpoint, :desired_capabilities => capabilities)
      end

      Environ.set_browser(browser)

      Capybara.default_driver = :crossbrowser
      Capybara.run_server = false
    end

    def self.initialize_poltergeist
      Capybara.default_driver = :poltergeist
      Capybara.register_driver :poltergeist do |app|
        options = {
            :js_errors => true,
            :timeout => 120,
            :debug => false,
            :phantomjs_options => ['--load-images=no', '--disk-cache=false'],
            :inspector => true,
        }
        Capybara::Poltergeist::Driver.new(app, options)
      end
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
        if ENV['SL_OS']
          capabilities['platform'] = ENV['SL_OS']
          Environ.set_platform(:desktop)
        elsif ENV['SL_PLATFORM']
          capabilities['platform'] = ENV['SL_PLATFORM']
          capabilities['deviceName'] = ENV['SL_DEVICE']
          capabilities['deviceType'] = ENV['SL_DEVICE_TYPE'] if ENV['SL_DEVICE_TYPE']
          capabilities['deviceOrientation'] = ENV['ORIENTATION'] if ENV['ORIENTATION']
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

      endpoint = "http://#{ENV['TB_USERNAME']}:#{ENV['TB_AUTHKEY']}@hub.testingbot.com:4444/wd/hub"
      Capybara.register_driver :testingbot do |app|
        capabilities = Selenium::WebDriver::Remote::Capabilities.new
        capabilities['name'] = ENV['AUTOMATE_PROJECT'] if ENV['AUTOMATE_PROJECT']
        capabilities['build'] = ENV['AUTOMATE_BUILD'] if ENV['AUTOMATE_BUILD']
        capabilities['browserName'] = browser
        capabilities['version'] = ENV['TB_VERSION'] if ENV['TB_VERSION']
        capabilities['screen-resolution'] = ENV['RESOLUTION'] if ENV['RESOLUTION']
        if ENV['TB_OS']
          capabilities['platform'] = ENV['TB_OS']
          Environ.set_platform(:desktop)
        elsif ENV['TB_PLATFORM']
          capabilities['platform'] = ENV['TB_PLATFORM']
          capabilities['browserName'] = ENV['TB_DEVICE']
          capabilities['version'] = ENV['TB_VERSION'] if ENV['TB_VERSION']
          Environ.set_platform(:mobile)
        end

        Capybara::Selenium::Driver.new(app, :browser => :remote, :url => endpoint, :desired_capabilities => capabilities)
      end

      Environ.set_browser(browser)

      Capybara.default_driver = :testingbot
      Capybara.run_server = false

    end
  end
end
