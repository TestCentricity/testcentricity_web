module TestCentricity
  class ExceptionQueue
    include Capybara::DSL

    @error_queue

    def self.enqueue_assert_equal(expected, actual, error_message)
      unless expected == actual
        enqueue("#{error_message} to be\n  #{expected}\nbut found\n  #{actual}")
        enqueue_screenshot
      end
    end

    def self.enqueue_assert_not_equal(expected, actual, error_message)
      unless expected != actual
        enqueue("#{error_message} to not be equal to #{expected}")
        enqueue_screenshot
      end
    end

    def self.enqueue_exception(error_message)
      enqueue(error_message)
    end

    def self.post_exceptions
      raise @error_queue unless @error_queue.nil?
    ensure
      @error_queue = nil
    end

    private

    def self.enqueue(message)
      @error_queue = "#{@error_queue}#{message}\n\n"
    end

    def self.enqueue_screenshot
      timestamp = Time.now.strftime('%Y%m%d%H%M%S')
      filename = "Screenshot-#{timestamp}"
      path = File.join Dir.pwd, 'reports/screenshots/', filename
      Capybara.save_screenshot "#{path}.png"
      puts "Screenshot saved at #{path}.png"
      screen_shot = { :path => path, :filename => filename }
      Environ.save_screen_shot(screen_shot)
    end
  end
end
