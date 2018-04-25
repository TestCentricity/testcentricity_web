module TestCentricity
  class EnvironData < TestCentricity::ExcelDataSource
    attr_accessor	:current

    WKS_ENVIRONS ||= 'Environments'

    def find_environ(environ_name, source_type = :excel)
      case source_type
      when :excel
        data = ExcelData.read_row_data(XL_PRIMARY_DATA_FILE, WKS_ENVIRONS, environ_name)
      when :yaml
        data = read_yaml_node_data('environments.yml', environ_name)
      when :json
        data = read_json_node_data('environments.json', environ_name)
      end
      @current = Environ.new(data)
      Environ.current = @current
    end
  end


  class Environ < TestCentricity::DataObject
    @session_id = Time.now.strftime('%d%H%M%S%L')
    @session_time_stamp = Time.now.strftime('%Y%m%d%H%M%S')
    @session_code
    @test_environment = ENV['TEST_ENVIRONMENT']
    @screen_shots = []

    attr_accessor :test_environment
    attr_accessor :browser
    attr_accessor :browser_size
    attr_accessor :session_state
    attr_accessor :os
    attr_accessor :device
    attr_accessor :device_name
    attr_accessor :device_type
    attr_accessor :device_os
    attr_accessor :device_orientation
    attr_accessor :platform
    attr_accessor :driver
    attr_accessor :tunneling

    attr_accessor :signed_in
    attr_accessor :portal_status
    attr_accessor :portal_context
    attr_accessor :external_page

    attr_accessor :protocol
    attr_accessor :hostname
    attr_accessor :base_url
    attr_accessor :user_id
    attr_accessor :password
    attr_accessor :append
    attr_accessor :option1
    attr_accessor :option2
    attr_accessor :dns
    attr_accessor :db_username
    attr_accessor :db_password

    def initialize(data)
      @protocol     	  = data['PROTOCOL']
      @hostname         = data['HOST_NAME']
      @base_url         = data['BASE_URL']
      @user_id	        = data['USER_ID']
      @password	        = data['PASSWORD']
      @append	          = data['APPEND']
      @option1	        = data['OPTIONAL_1']
      @option2	        = data['OPTIONAL_2']
      @dns	            = data['DNS']
      @db_username      = data['DB_USERNAME']
      @db_password      = data['DB_PASSWORD']
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

    def self.tunneling=(state)
      @tunneling = state
    end

    def self.tunneling
      @tunneling
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
  end
end
