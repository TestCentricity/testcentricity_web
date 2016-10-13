require 'test/unit'

Capybara::Node::Element.class_eval do
  def click_at(x, y)
    right = x - (native.size.width / 2)
    top = y - (native.size.height / 2)
    driver.browser.action.move_to(native).move_by(right.to_i, top.to_i).click.perform
  end

  def get_width
    native.size.width
  end

  def get_height
    native.size.height
  end
end


module TestCentricity
  class UIElement
    include Capybara::DSL
    include Test::Unit::Assertions

    attr_reader   :parent, :locator, :context, :type, :name
    attr_accessor :alt_locator

    def initialize(name, parent, locator, context)
      @name        = name
      @parent      = parent
      @locator     = locator
      @context     = context
      @type        = nil
      @alt_locator = nil
    end

    def get_object_type
      if @type
        @type
      elsif obj.tag_name
        obj.tag_name
      elsif obj.native.attribute('type')
        obj.native.attribute('type')
      end
    end

    def get_locator
      @locator
    end

    def get_name
      @name
    end

    def set_alt_locator(temp_locator)
      @alt_locator = temp_locator
    end

    def clear_alt_locator
      @alt_locator = nil
    end

    # Click on an object
    #
    # @example
    #   basket_link.click
    #
    def click
      obj, _ = find_element
      object_not_found_exception(obj, nil)
      begin
        obj.click
      rescue
        obj.click_at(10, 10) unless Capybara.current_driver == :poltergeist
      end
    end

    # Double-click on an object
    #
    # @example
    #   file_image.double_click
    #
    def double_click
      obj, _ = find_element
      object_not_found_exception(obj, nil)
      page.driver.browser.action.double_click(obj.native).perform
    end

    # Right-click on an object
    #
    # @example
    #   basket_item_image.right_click
    #
    def right_click
      obj, _ = find_element
      object_not_found_exception(obj, nil)
      page.driver.browser.action.context_click(obj.native).perform
    end

    # Click at a specific location within an object
    #
    # @param x [Integer] X offset
    # @param y [Integer] Y offset
    # @example
    #   basket_item_image.click_at(10, 10)
    #
    def click_at(x, y)
      obj, _ = find_element
      raise "UI object '#{get_name}' (#{get_locator}) not found" unless obj
      obj.click_at(x, y)
    end

    def set(value)
      obj, _ = find_element
      object_not_found_exception(obj, nil)
      obj.set(value)
    end

    # Send keystrokes to this object.
    #
    # @param keys [String] keys
     # @example
    #   comment_field.send_keys(:enter)
    #
    def send_keys(*keys)
      obj, _ = find_element
      object_not_found_exception(obj, nil)
      obj.send_keys(*keys)
    end

    # Does UI object exists?
    #
    # @return [Boolean]
    # @example
    #   basket_link.exists?
    #
    def exists?(visible = true)
      obj, _ = find_object(visible)
      obj != nil
    end

    # Is UI object visible?
    #
    # @return [Boolean]
    # @example
    #   remember_me_checkbox.visible?
    #
    def visible?
      obj, type = find_object
      exists = obj
      invisible = false
      if type == :css
        Capybara.using_wait_time 0.1 do
          # is object itself hidden with .ui-helper-hidden class?
          self_hidden = page.has_css?("#{@locator}.ui-helper-hidden")
          # is parent of object hidden, thus hiding the object?
          parent_hidden = page.has_css?(".ui-helper-hidden > #{@locator}")
          # is grandparent of object, or any other ancestor, hidden?
          other_ancestor_hidden = page.has_css?(".ui-helper-hidden * #{@locator}")
          # if any of the above conditions are true, then object is invisible
          invisible = self_hidden || parent_hidden || other_ancestor_hidden
        end
      else
        invisible = !obj.visible? if exists
      end
      # the object is visible if it exists and it is not invisible
      (exists && !invisible) ? true : false
    end

    # Is UI object hidden (not visible)?
    #
    # @return [Boolean]
    # @example
    #   remember_me_checkbox.hidden?
    #
    def hidden?
      not visible?
    end

    # Is UI object enabled?
    #
    # @return [Boolean]
    # @example
    #   login_button.enabled?
    #
    def enabled?
      not disabled?
    end

    # Is UI object disabled (not enabled)?
    #
    # @return [Boolean]
    # @example
    #   login_button.disabled?
    #
    def disabled?
      obj, _ = find_element
      object_not_found_exception(obj, nil)
      obj.disabled?
    end

    # Wait until the object exists, or until the specified wait time has expired.
    #
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   run_button.wait_until_exists(0.5)
    #
    def wait_until_exists(seconds = nil)
      timeout = seconds.nil? ? Capybara.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { exists? }
    rescue
      raise "Could not find UI object '#{get_name}' (#{get_locator}) after #{timeout} seconds" unless exists?
    end

    # Wait until the object no longer exists, or until the specified wait time has expired.
    #
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   logout_button.wait_until_gone(5)
    #
    def wait_until_gone(seconds = nil)
      timeout = seconds.nil? ? Capybara.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { !exists? }
    rescue
      raise "UI object '#{get_name}' (#{get_locator}) remained visible after #{timeout} seconds" if exists?
    end

    # Wait until the object is visible, or until the specified wait time has expired.
    #
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   run_button.wait_until_visible(0.5)
    #
    def wait_until_visible(seconds = nil)
      timeout = seconds.nil? ? Capybara.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { visible? }
    rescue
      raise "Could not find UI object '#{get_name}' (#{get_locator}) after #{timeout} seconds" unless visible?
    end

    # Wait until the object is hidden, or until the specified wait time has expired.
    #
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   run_button.wait_until_hidden(10)
    #
    def wait_until_hidden(seconds = nil)
      timeout = seconds.nil? ? Capybara.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { hidden? }
    rescue
      raise "UI object '#{get_name}' (#{get_locator}) remained visible after #{timeout} seconds" if visible?
    end

    # Wait until the object's value equals the specified value, or until the specified wait time has expired.
    #
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   card_authorized_label.wait_until_value_is(5, 'Card authorized')
    #
    def wait_until_value_is(value, seconds = nil)
      timeout = seconds.nil? ? Capybara.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { get_value == value }
    rescue
      raise "Value of UI object '#{get_name}' (#{get_locator}) failed to equal '#{value}' after #{timeout} seconds" unless get_value == value
    end

    # Wait until the object's value changes to a different value, or until the specified wait time has expired.
    #
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   basket_grand_total_label.wait_until_value_changes(5)
    #
    def wait_until_value_changes(seconds = nil)
      value = get_value
      timeout = seconds.nil? ? Capybara.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { get_value != value }
    rescue
      raise "Value of UI object '#{get_name}' (#{get_locator}) failed to change from '#{value}' after #{timeout} seconds" if get_value == value
    end

    def get_value(visible = true)
      obj, _ = find_element(visible)
      object_not_found_exception(obj, nil)
      case obj.tag_name.downcase
        when 'input', 'select', 'textarea'
          obj.value
        else
          obj.text
      end
    end

    alias :get_caption :get_value

    def verify_value(expected, enqueue = false)
      actual = get_value
      enqueue ?
          ExceptionQueue.enqueue_assert_equal(expected.strip, actual.strip, "Expected UI object '#{get_name}' (#{get_locator})") :
          assert_equal(expected.strip, actual.strip, "Expected UI object '#{get_name}' (#{get_locator}) to display '#{expected}' but found '#{actual}'")
    end

    alias :verify_caption :verify_value

    # Hover the cursor over an object
    #
    # @example
    #   basket_link.hover
    #
    def hover
      obj, _ = find_element
      object_not_found_exception(obj, nil)
      obj.hover
    end

    def drag_by(right_offset, down_offset)
      obj, _ = find_element
      object_not_found_exception(obj, nil)
      obj.drag_by(right_offset, down_offset)
    end

    def drag_and_drop(target, right_offset = nil, down_offset = nil)
      source, _ = find_element
      object_not_found_exception(source, nil)
      page.driver.browser.action.click_and_hold(source.native).perform
      sleep(0.5)
      target_drop, _ = target.find_element
      page.driver.browser.action.move_to(target_drop.native, right_offset.to_i, down_offset.to_i).release.perform
    end

    def get_attribute(attrib)
      obj, _ = find_element
      object_not_found_exception(obj, nil)
      obj[attrib]
    end

    def get_native_attribute(attrib)
      obj, _ = find_element
      object_not_found_exception(obj, nil)
      obj.native.attribute(attrib)
    end

    private

    def find_element(visible = true)
      wait = Selenium::WebDriver::Wait.new(timeout: Capybara.default_max_wait_time)
      wait.until { find_object(visible) }
    end

    def find_object(visible = true)
      @alt_locator.nil? ? locator = @locator : locator = @alt_locator
      tries ||= 6
      attributes = [:id, :xpath_ignore_parent, :css_ignore_parent, :xpath_css, :css_xpath, :xpath, :css]
      type = attributes[tries]
      if @context == :section && !@parent.get_locator.nil?
        parent_locator = @parent.get_locator
        case type
          when :css
            parent_locator = parent_locator.gsub('|', ' ')
            obj = page.find(:css, parent_locator, :wait => 0.01).find(:css, locator, :wait => 0.01, :visible => visible)
          when :xpath
            parent_locator = parent_locator.gsub('|', '')
            obj = page.find(:xpath, "#{parent_locator}#{locator}", :wait => 0.01, :visible => visible)
          when :css_xpath
            type = :xpath
            parent_locator = parent_locator.gsub('|', ' ')
            obj = page.find(:css, parent_locator, :wait => 0.01).find(:xpath, locator, :wait => 0.01, :visible => visible)
          when :xpath_css
            type = :css
            parent_locator = parent_locator.gsub('|', ' ')
            obj = page.find(:xpath, parent_locator, :wait => 0.01).find(:css, locator, :wait => 0.01, :visible => visible)
          when :css_ignore_parent
            type = :css
            obj = page.find(:css, locator, :wait => 0.01, :visible => visible)
          when :xpath_ignore_parent
            type = :xpath
            obj = page.find(:xpath, locator, :wait => 0.01, :visible => visible)
        end
      else
        obj = page.find(type, locator, :wait => 0.01, :visible => visible)
      end
      [obj, type]
    rescue
      retry if (tries -= 1) > 0
      [nil, nil]
    end

    def object_not_found_exception(obj, obj_type)
      @alt_locator.nil? ? locator = @locator : locator = @alt_locator
      obj_type.nil? ? object_type = "Object" : object_type = obj_type
      raise "#{object_type} named '#{@name}' (#{locator}) not found" unless obj
    end

    def invalid_object_type_exception(obj, obj_type)
      unless obj.tag_name == obj_type || obj.native.attribute('type') == obj_type
        @alt_locator.nil? ? locator = @locator : locator = @alt_locator
        raise "#{locator} is not a #{obj_type} element"
      end
    end

    def invoke_siebel_popup
      obj, _ = find_element
      object_not_found_exception(obj, 'Siebel object')
      trigger_name = obj.native.attribute('aria-describedby').strip
      trigger = "span##{trigger_name}"
      trigger = "#{@parent.get_locator} #{trigger}" if @context == :section && !@parent.get_locator.nil?
      first(trigger).click
    end
  end
end
