module TestCentricity
  class ExceptionQueue
    @error_queue

    def self.enqueue_assert_equal(expected, actual, error_message)
      unless expected == actual
        @error_queue = "#{@error_queue}#{error_message} to be\n  #{expected}\nbut found\n  #{actual}\n\n"
        screen_shot_and_save_page
      end
    end

    def self.enqueue_assert_not_equal(expected, actual, error_message)
      unless expected != actual
        @error_queue = "#{@error_queue}#{error_message} to not be equal to #{expected}\n\n"
        screen_shot_and_save_page
      end
    end

    def self.enqueue_exception(error_message)
      @error_queue = "#{@error_queue}#{error_message}\n\n"
    end

    def self.post_exceptions
      raise @error_queue unless @error_queue.nil?
    ensure
      @error_queue = nil
    end
  end

  private


  def self.screen_shot_and_save_page
    timestamp = Time.now.strftime('%Y%m%d%H%M%S')
    filename = "Screenshot-#{timestamp}"
    path = File.join Dir.pwd, "reports/screenshots/", filename
    save_screenshot "#{path}.png"
    puts "Screenshot saved at #{path}.png"
    screen_shot = { :path => path, :filename => filename }
    Environ.save_screen_shot(screen_shot)
  end
end
