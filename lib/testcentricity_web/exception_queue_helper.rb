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
            expected = translate(value)
            enqueue_assert_equal(expected, actual, error_msg)
          when :translate_upcase
            expected = translate(value)
            expected = expected.is_a?(Array) ? expected.map(&:upcase) : expected.upcase
            enqueue_assert_equal(expected, actual, error_msg)
          when :translate_downcase
            expected = translate(value)
            expected = expected.is_a?(Array) ? expected.map(&:downcase) : expected.downcase
            enqueue_assert_equal(expected, actual, error_msg)
          when :translate_capitalize
            expected = translate(value)
            expected = expected.is_a?(Array) ? expected.map(&:capitalize) : expected.capitalize
            enqueue_assert_equal(expected, actual, error_msg)
          when :translate_titlecase
            expected = translate(value)
            expected = if expected.is_a?(Array)
                         result = []
                         expected.each do |item|
                           result.push("#{item.split.each{ |item| item.capitalize! }.join(' ')}")
                         end
                         result
                       else
                         "#{expected.split.each{ |expected| expected.capitalize! }.join(' ')}"
                       end
            enqueue_assert_equal(expected, actual, error_msg)
          else
            raise "#{key} is not a valid comparison key"
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
      timestamp = Time.now.strftime('%Y%m%d%H%M%S%L')
      filename = "Screenshot-#{timestamp}.png"
      path = File.join Dir.pwd, 'reports/screenshots/', filename
      # scroll into view and highlight the active UI element prior to taking a screenshot
      unless @active_ui_element.nil? || @mru_ui_element == @active_ui_element
        @active_ui_element.scroll_to(:bottom)
        @active_ui_element.highlight(0)
        @mru_ui_element = @active_ui_element
      end
      # take screenshot
      Capybara.save_screenshot path
      # unhighlight the active UI element
      @mru_ui_element.unhighlight unless @mru_ui_element.blank?
      # add screenshot to queue
      puts "Screenshot saved at #{path}"
      screen_shot = {path: path, filename: filename}
      Environ.save_screen_shot(screen_shot)
    end

    def self.translate(*args, **opts)
      opts[:locale] ||= I18n.locale
      opts[:raise] = true
      I18n.translate(*args, **opts)
    rescue I18n::MissingTranslationData => err
      puts err
      opts[:locale] = :en

      # fallback to en if the translation is missing. If the translation isn't
      # in en, then raise again.
      disable_enforce_available_locales do
        I18n.translate(*args, **opts)
      end
    end

    def self.disable_enforce_available_locales
      saved_enforce_available_locales = I18n.enforce_available_locales
      I18n.enforce_available_locales = false
      yield
    ensure
      I18n.enforce_available_locales = saved_enforce_available_locales
    end
  end


  class ObjectNotFoundError < StandardError
    def initialize(message)
      super(message)
    end
  end
end
