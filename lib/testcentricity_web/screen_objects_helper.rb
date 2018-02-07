require 'test/unit'

module TestCentricity
  class ScreenObject
    include Test::Unit::Assertions

    def self.trait(trait_name, &block)
      define_method(trait_name.to_s, &block)
    end

    def self.element(element_name, locator)
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::AppUIElement.new("#{element_name}", self, "#{locator}", :page);end))
    end

    def self.button(element_name, locator)
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::AppButton.new("#{element_name}", self, "#{locator}", :page);end))
    end

    def self.textfield(element_name, locator)
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::AppTextField.new("#{element_name}", self, "#{locator}", :page);end))
    end

    def self.checkbox(element_name, locator, proxy = nil)
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::AppCheckBox.new("#{element_name}", self, "#{locator}", :page, #{proxy});end))
    end

    def self.label(element_name, locator)
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::AppLabel.new("#{element_name}", self, "#{locator}", :page);end))
    end

    def open_portal
      environment = Environ.current

      Environ.portal_state = :open
    end

    def verify_page_exists
      raise "Screen object #{self.class.name} does not have a page_locator trait defined" unless defined?(page_locator)
      unless page.has_selector?(page_locator)
        body_class = find(:xpath, '//body')[:class]
        error_message = %(
          Expected page to have selector '#{page_locator}' but found '#{body_class}' instead.
          Actual URL of page loaded = #{URI.parse(current_url)}.
          )
        error_message = "#{error_message}\nExpected URL of page was #{page_url}." if defined?(page_url)
        raise error_message
      end
    end

    def navigate_to; end

    def verify_page_ui; end

    def load_page
      return if exists?
      if defined?(page_url) && !page_url.nil?
        visit page_url
        begin
          page.driver.browser.switch_to.alert.accept
        rescue => e
        end unless Environ.browser == :safari || Environ.browser == :ie || Environ.is_device?
      else
        navigate_to
      end
      verify_page_exists
      PageManager.current_page = self
    end


    def verify_ui_states(ui_states)
      ui_states.each do |ui_object, object_states|
        object_states.each do |property, state|
          case property
          when :exists
            actual = ui_object.exists?
          when :enabled
            actual = ui_object.enabled?
          when :disabled
            actual = ui_object.disabled?
          when :visible
            actual = ui_object.visible?
          when :hidden
            actual = ui_object.hidden?
          when :checked
            actual = ui_object.checked?
          when :value, :caption
            actual = ui_object.get_value
          end

          if state.is_a?(Hash) && state.length == 1
            error_msg = "Expected UI object '#{ui_object.get_name}' (#{ui_object.get_locator}) #{property} property to"
            state.each do |key, value|
              case key
              when :lt, :less_than
                ExceptionQueue.enqueue_exception("#{error_msg} be less than #{value} but found '#{actual}'") unless actual < value
              when :lt_eq, :less_than_or_equal
                ExceptionQueue.enqueue_exception("#{error_msg} be less than or equal to #{value} but found '#{actual}'") unless actual <= value
              when :gt, :greater_than
                ExceptionQueue.enqueue_exception("#{error_msg} be greater than #{value} but found '#{actual}'") unless actual > value
              when :gt_eq, :greater_than_or_equal
                ExceptionQueue.enqueue_exception("#{error_msg} be greater than or equal to  #{value} but found '#{actual}'") unless actual >= value
              when :starts_with
                ExceptionQueue.enqueue_exception("#{error_msg} start with '#{value}' but found '#{actual}'") unless actual.start_with?(value)
              when :ends_with
                ExceptionQueue.enqueue_exception("#{error_msg} end with '#{value}' but found '#{actual}'") unless actual.end_with?(value)
              when :contains
                ExceptionQueue.enqueue_exception("#{error_msg} contain '#{value}' but found '#{actual}'") unless actual.include?(value)
              when :not_contains, :does_not_contain
                ExceptionQueue.enqueue_exception("#{error_msg} not contain '#{value}' but found '#{actual}'") if actual.include?(value)
              when :not_equal
                ExceptionQueue.enqueue_exception("#{error_msg} not equal '#{value}' but found '#{actual}'") if actual == value
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
                ExceptionQueue.enqueue_exception("#{error_msg} be like '#{value}' but found '#{actual}'") unless actual_like.include?(expected)
              when :translate
                expected = I18n.t(value)
                ExceptionQueue.enqueue_assert_equal(expected, actual, "Expected UI object '#{ui_object.get_name}' (#{ui_object.get_locator}) translated #{property} property")
              end
            end
          else
            ExceptionQueue.enqueue_assert_equal(state, actual, "Expected UI object '#{ui_object.get_name}' (#{ui_object.get_locator}) #{property} property")
          end
        end
      end
      ExceptionQueue.post_exceptions
    end

    def populate_data_fields(data, wait_time = nil)
      timeout = wait_time.nil? ? 5 : wait_time
      data.each do |data_field, data_param|
        unless data_param.blank?
          # make sure the intended UI target element is visible before trying to set its value
          data_field.wait_until_visible(timeout)
          if data_param == '!DELETE'
            data_field.clear
          else
            case data_field.get_object_type
            when :checkbox
              data_field.set_checkbox_state(data_param.to_bool)
            when :textfield
              data_field.set("#{data_param}\t")
            end
          end
        end
      end
    end
  end
end
