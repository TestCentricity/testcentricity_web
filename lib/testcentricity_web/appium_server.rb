require 'childprocess'

#
# This class is designed to start and stop the Appium Server process.  In order to use it you must have Appium
# and node installed on your computer.  You can pass parameters to Appium at startup via the constructor.
#
module TestCentricity
  class AppiumServer
    attr_accessor :process

    def initialize(params = {})
      @params = params
    end

    #
    # Start the Appium Server
    #
    def start
      # terminate any currently running Appium Server
      if running?
        system('killall -9 node')
        puts 'Terminating existing Appium Server'
        sleep(5)
        puts 'Appium Server is being restarted'
      else
        puts 'Appium Server is starting'
      end
      # start new Appium Server
      @process = ChildProcess.build(*parameters)
      process.start
      # wait until confirmation that Appium Server is running
      wait = Selenium::WebDriver::Wait.new(timeout: 30)
      wait.until { running? }
      puts "Appium Server is running - PID = #{process.pid}"
    end

    #
    # Check to see if Appium Server is running
    #
    def running?
      endpoint = 'http://0.0.0.0:4723/sessions'
      response = false
      begin
        response = Net::HTTP.get_response(URI(endpoint))
      rescue
      end
      response && response.code_type == Net::HTTPOK
    end

    #
    # Stop the Appium Server
    #
    def stop
      process.stop
      puts 'Appium Server has been terminated'
    end

    private

    # :nocov:
    def parameters
      cmd = ['appium']
      @params.each do |key, value|
        cmd << '--' + key.to_s
        cmd << value.to_s if not value.nil? and value.size > 0
      end
      cmd
    end
    # :nocov:
  end
end

