module TestCentricity
  class EnvironData < TestCentricity::ExcelDataSource
    attr_accessor	:current

    WKS_ENVIRONS ||= 'Environments'

    def find_environ(environ_name, source_type = :excel)
      data = case source_type
             when :excel
               ExcelData.read_row_data(XL_PRIMARY_DATA_FILE, WKS_ENVIRONS, environ_name)
             when :yaml
               read_yaml_node_data('environments.yml', environ_name)
             when :json
               read_json_node_data('environments.json', environ_name)
             end
      @current = Environ.new(data)
      Environ.current = @current
    end
  end


  class Environ < TestCentricity::DataObject
    @session_id = Time.now.strftime('%d%H%M%S%L')
    @session_time_stamp = Time.now.strftime('%Y%m%d%H%M%S')
    @test_environment = ENV['TEST_ENVIRONMENT']
    @screen_shots = []

    attr_accessor :test_environment
    attr_accessor :browser
    attr_accessor :browser_size
    attr_accessor :headless
    attr_accessor :session_state
    attr_accessor :session_code
    attr_accessor :os
    attr_accessor :device
    attr_accessor :device_name
    attr_accessor :device_type
    attr_accessor :device_os
    attr_accessor :device_os_version
    attr_accessor :device_orientation
    attr_accessor :platform
    attr_accessor :driver
    attr_accessor :grid
    attr_accessor :tunneling
    attr_accessor :locale
    attr_accessor :language

    attr_accessor :parallel
    attr_accessor :process_num

    attr_accessor :signed_in
    attr_accessor :portal_status
    attr_accessor :portal_context
    attr_accessor :external_page

    attr_accessor :a11y_standard

    attr_accessor :protocol
    attr_accessor :hostname
    attr_accessor :base_url
    attr_accessor :user_id
    attr_accessor :password
    attr_accessor :append
    attr_accessor :app_id
    attr_accessor :api_key
    attr_accessor :option1
    attr_accessor :option2
    attr_accessor :option3
    attr_accessor :option4
    attr_accessor :dns
    attr_accessor :db_username
    attr_accessor :db_password

    def initialize(data)
      @protocol      = data['PROTOCOL']
      @hostname      = data['HOST_NAME']
      @base_url      = data['BASE_URL']
      @user_id	     = data['USER_ID']
      @password	     = data['PASSWORD']
      @append	       = data['APPEND']
      @app_id 	     = data['APP_ID']
      @api_key	     = data['API_KEY']
      @option1	     = data['OPTIONAL_1']
      @option2	     = data['OPTIONAL_2']
      @option3	     = data['OPTIONAL_3']
      @option4	     = data['OPTIONAL_4']
      @dns	         = data['DNS']
      @db_username   = data['DB_USERNAME']
      @db_password   = data['DB_PASSWORD']
      @a11y_standard = ENV['ACCESSIBILITY_STANDARD'] || 'best-practice'
      @locale        = ENV['LOCALE'] || 'en'
      @language      = ENV['LANGUAGE'] || 'English'

      super
    end

    def self.session_code
      if @session_code.nil?
        characters = ('a'..'z').to_a
        @session_code = (0..12).map { characters.sample }.join
      end
      @session_code
    end

    def self.session_id
      @session_id
    end

    def self.session_time_stamp
      @session_time_stamp
    end

    def self.parallel=(state)
      @parallel = state
    end

    def self.parallel
      @parallel
    end

    def self.process_num=(num)
      @process_num = num
    end

    def self.process_num
      @process_num
    end

    def self.test_environment
      if @test_environment.blank?
        nil
      else
        @test_environment.downcase.to_sym
      end
    end

    def self.browser=(browser)
      @browser = browser.downcase.to_sym
    end

    def self.browser
      @browser
    end

    def self.browser_size=(size)
      @browser_size = size
    end

    def self.browser_size
      @browser_size
    end

    def self.headless=(state)
      @headless = state
    end

    def self.headless
      @headless
    end

    def self.session_state=(session_state)
      @session_state = session_state
    end

    def self.session_state
      @session_state
    end

    def self.os=(os)
      @os = os
    end

    def self.os
      @os
    end

    def self.device=(device)
      @device = device
    end

    def self.device
      @device
    end

    def self.is_device?
      @device == :device
    end

    def self.is_simulator?
      @device == :simulator
    end

    def self.is_web?
      @device == :web
    end

    def self.device_type=(type)
      @device_type = type.downcase.to_sym
    end

    def self.device_type
      @device_type
    end

    def self.device_name=(name)
      @device_name = name
    end

    def self.device_name
      @device_name
    end

    def self.device_os=(os)
      @device_os = os.downcase.to_sym
    end

    def self.device_os
      @device_os
    end

    def self.device_os_version=(version)
      @device_os_version = version
    end

    def self.device_os_version
      @device_os_version
    end

    def self.is_ios?
      @device_os == :ios
    end

    def self.is_android?
      @device_os == :android
    end

    def self.device_orientation=(orientation)
      @device_orientation = orientation.downcase.to_sym
    end

    def self.device_orientation
      @device_orientation
    end

    def self.driver=(type)
      @driver = type
    end

    def self.driver
      @driver
    end

    def self.grid=(type)
      @grid = type
    end

    def self.grid
      @grid
    end

    def self.tunneling=(state)
      @tunneling = state
    end

    def self.tunneling
      @tunneling
    end

    def self.language=(language)
      @language = language
    end

    def self.language
      @language
    end

    def self.locale=(locale)
      @locale = locale
    end

    def self.locale
      @locale
    end

    def self.platform=(platform)
      @platform = platform
    end

    def self.is_mobile?
      @platform == :mobile
    end

    def self.is_desktop?
      @platform == :desktop
    end

    def self.set_signed_in(signed_in)
      @signed_in = signed_in
    end

    def self.is_signed_in?
      @signed_in
    end

    def self.portal_state=(portal_state)
      @portal_status = portal_state
    end

    def self.portal_state
      @portal_status
    end

    def self.portal_context=(portal_context)
      @portal_context = portal_context
    end

    def self.portal_context
      @portal_context
    end

    def self.set_external_page(state)
      @external_page = state
    end

    def self.external_page
      @external_page
    end

    def self.save_screen_shot(screen_shot)
      @screen_shots.push(screen_shot)
    end

    def self.get_screen_shots
      @screen_shots
    end

    def self.reset_contexts
      @screen_shots = []
    end

    def self.report_header
      report_header = "\n<b><u>TEST ENVIRONMENT</u>:</b> #{ENV['TEST_ENVIRONMENT']}\n"\
      "  <b>Browser:</b>\t #{Environ.browser.capitalize}\n"
      report_header = "#{report_header}  <b>Device:</b>\t\t #{Environ.device_name}\n" if Environ.device_name
      report_header = "#{report_header}  <b>Device OS:</b>\t #{Environ.device_os} #{Environ.device_os_version}\n" if Environ.device_os
      report_header = "#{report_header}  <b>Device type:</b>\t #{Environ.device_type}\n" if Environ.device_type
      report_header = "#{report_header}  <b>Driver:</b>\t\t #{Environ.driver}\n" if Environ.driver
      report_header = "#{report_header}  <b>Grid:</b>\t\t #{Environ.grid}\n" if Environ.grid
      report_header = "#{report_header}  <b>OS:</b>\t\t\t #{Environ.os}\n" if Environ.os
      report_header = "#{report_header}  <b>Locale:</b>\t\t #{Environ.locale}\n" if Environ.locale
      report_header = "#{report_header}  <b>Language:</b>\t #{Environ.language}\n" if Environ.language
      report_header = "#{report_header}  <b>Country:</b>\t #{ENV['COUNTRY']}\n" if ENV['COUNTRY']
      report_header = "#{report_header}  <b>WCAG Accessibility Standard:</b>\t #{ENV['ACCESSIBILITY_STANDARD']}\n" if ENV['ACCESSIBILITY_STANDARD']
      "#{report_header}\n\n"
    end
  end
end
