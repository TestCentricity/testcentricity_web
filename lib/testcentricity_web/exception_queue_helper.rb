module TestCentricity
  class ExceptionQueue
    include Capybara::DSL

    @error_queue

    def self.enqueue_assert_equal(expected, actual, error_message)
      unless expected == actual
        enqueue("#{error_message} to be\n  '#{expected}'\nbut found\n  '#{actual}'")
        enqueue_screenshot
      end
    end

    def self.enqueue_assert_not_equal(expected, actual, error_message)
      unless expected != actual
        enqueue("#{error_message} to not be equal to '#{expected}'")
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

    def self.enqueue_comparison(state, actual, error_msg)
      if state.is_a?(Hash) && state.length == 1
        state.each do |key, value|
          case key
            when :lt, :less_than
              enqueue_exception("#{error_msg} be less than #{value} but found '#{actual}'") unless actual < value
            when :lt_eq, :less_than_or_equal
              enqueue_exception("#{error_msg} be less than or equal to #{value} but found '#{actual}'") unless actual <= value
            when :gt, :greater_than
              enqueue_exception("#{error_msg} be greater than #{value} but found '#{actual}'") unless actual > value
            when :gt_eq, :greater_than_or_equal
              enqueue_exception("#{error_msg} be greater than or equal to  #{value} but found '#{actual}'") unless actual >= value
            when :starts_with
              enqueue_exception("#{error_msg} start with '#{value}' but found '#{actual}'") unless actual.start_with?(value)
            when :ends_with
              enqueue_exception("#{error_msg} end with '#{value}' but found '#{actual}'") unless actual.end_with?(value)
            when :contains
              enqueue_exception("#{error_msg} contain '#{value}' but found '#{actual}'") unless actual.include?(value)
            when :not_contains, :does_not_contain
              enqueue_exception("#{error_msg} not contain '#{value}' but found '#{actual}'") if actual.include?(value)
            when :not_equal
              enqueue_exception("#{error_msg} not equal '#{value}' but found '#{actual}'") if actual == value
            when :like, :is_like
              actual_like = actual.delete("\n")
              actual_like = actual_like.delete("\r")
              actual_like = actual_like.delete("\t")
              actual_like = actual_like.delete(' ')
              actual_like = actual_like.downcase
              expected    = value.delete("\n")
              expected    = expected.delete("\r")
              expected    = expected.delete("\t")
              expected    = expected.delete(' ')
              expected    = expected.downcase
              enqueue_exception("#{error_msg} be like '#{value}' but found '#{actual}'") unless actual_like.include?(expected)
            when :translate
              expected = I18n.t(value)
              enqueue_assert_equal(expected, actual, error_msg)
          end
        end
      else
        enqueue_assert_equal(state, actual, error_msg)
      end
    end

    private

    def self.enqueue(message)
      @error_queue = "#{@error_queue}#{message}\n\n"
    end

    def self.enqueue_screenshot
      timestamp = Time.now.strftime('%Y%m%d%H%M%S')
      filename = "Screenshot-#{timestamp}"
      path = File.join Dir.pwd, 'reports/screenshots/', filename
      if Environ.driver == :appium
        AppiumConnect.take_screenshot("#{path}.png")
      else
        Capybara.save_screenshot "#{path}.png"
      end
      puts "Screenshot saved at #{path}.png"
      screen_shot = { :path => path, :filename => filename }
      Environ.save_screen_shot(screen_shot)
    end
  end


  class ObjectNotFoundError < StandardError
    def initialize(message)
      super(message)
    end
  end
end
