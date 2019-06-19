module TestCentricity
  class ExceptionQueue
    include Capybara::DSL

    attr_accessor :error_queue
    attr_accessor :active_ui_element
    attr_accessor :mru_ui_element

    def self.enqueue_assert_equal(expected, actual, error_message)
      is_equal = if %i[edge safari].include?(Environ.browser) && expected.is_a?(String) && actual.is_a?(String)
                   expected.downcase.strip == actual.downcase.strip
                 else
                   expected == actual
                 end
      unless is_equal
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

    def self.post_exceptions(preample_message = nil)
      unless @error_queue.nil?
        @error_queue = "#{preample_message} - The following errors were found:\n_______________________________\n#{@error_queue}" unless preample_message.nil?
        raise @error_queue
      end
    ensure
      @error_queue = nil
      @active_ui_element = nil
      @mru_ui_element = nil
    end

    def self.enqueue_comparison(ui_object, state, actual, error_msg)
      @active_ui_element = ui_object
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
          when :translate_upcase
            expected = I18n.t(value).upcase
            enqueue_assert_equal(expected, actual, error_msg)
          when :translate_downcase
            expected = I18n.t(value).downcase
            enqueue_assert_equal(expected, actual, error_msg)
          when :translate_capitalize
            expected = I18n.t(value).capitalize
            enqueue_assert_equal(expected, actual, error_msg)
          when :translate_titlecase
            expected = I18n.t(value)
            expected = "#{expected.split.each{ |expected| expected.capitalize! }.join(' ')}"
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
      # highlight the active UI element prior to taking a screenshot
      unless @active_ui_element.nil? || @mru_ui_element == @active_ui_element
        @active_ui_element.highlight(0)
        @mru_ui_element = @active_ui_element
      end
      # take screenshot
      if Environ.driver == :appium
        AppiumConnect.take_screenshot("#{path}.png")
      else
        Capybara.save_screenshot "#{path}.png"
      end
      # unhighlight the active UI element
      @mru_ui_element.unhighlight unless @mru_ui_element.blank?
      # add screenshot to queue
      puts "Screenshot saved at #{path}.png"
      screen_shot = {path: path, filename: filename}
      Environ.save_screen_shot(screen_shot)
    end
  end


  class ObjectNotFoundError < StandardError
    def initialize(message)
      super(message)
    end
  end
end
