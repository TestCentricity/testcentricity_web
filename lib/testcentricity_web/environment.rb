module TestCentricity
  class EnvironData < TestCentricity::ExcelDataSource
    attr_accessor		:current

    WKS_ENVIRONS ||= 'Environments'

    def find_environ(row_name)
      @current = Environ.new(ExcelData.read_row_data(XL_PRIMARY_DATA_FILE, WKS_ENVIRONS, row_name))
      Environ.set_current(@current)
    end
  end


  class Environ < TestCentricity::DataObject
    @session_id = Time.now.strftime('%d%H%M%S%L')
    @session_time_stamp = Time.now.strftime('%Y%m%d%H%M%S')
    @session_code

    @screen_shots = []

    attr_accessor :browser
    attr_accessor :os
    attr_accessor :device
    attr_accessor :device_type
    attr_accessor :platform
    attr_accessor :signed_in
    attr_accessor :portal_status

    attr_reader   :protocol
    attr_reader   :hostname
    attr_reader   :base_url
    attr_reader   :user_id
    attr_reader   :password
    attr_reader   :append

    def initialize(data)
      @protocol	= data['PROTOCOL']
      @hostname = data['HOST_NAME']
      @base_url	= data['BASE_URL']
      @user_id	= data['USER_ID']
      @password	= data['PASSWORD']
      @append	  = data['APPEND']
      super
    end

    def self.session_code
      if @session_code == nil
        characters = ('a'..'z').to_a
        @session_code = (0..12).map{characters.sample}.join
      end
      @session_code
    end

    def self.session_id
      @session_id
    end

    def self.session_time_stamp
      @session_time_stamp
    end

    def self.set_browser(browser)
      @browser = browser.downcase.to_sym
    end

    def self.browser
      @browser
    end

    def self.set_os(os)
      @os = os
    end

    def self.os
      @os
    end

    def self.set_device(device)
      @device = device
    end

    def self.is_device?
      @device
    end

    def self.set_device_type(type)
      @device_type = type.downcase
    end

    def self.device_type
      @device_type
    end

    def self.set_platform(platform)
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

    def self.set_portal_state(portal_state)
      @portal_status = portal_state
    end

    def self.portal_state
      @portal_status
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
