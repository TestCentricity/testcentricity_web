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

  def get_x
    native.location.x
  end

  def get_y
    native.location.y
  end

  def displayed?
    native.displayed?
  end
end


module TestCentricity
  class UIElement
    include Capybara::DSL
    include Test::Unit::Assertions

    attr_reader   :parent, :locator, :context, :type, :name
    attr_accessor :alt_locator, :locator_type

    XPATH_SELECTORS = ['//', '[@', '[contains(@']
    CSS_SELECTORS   = ['#', ':nth-child(', ':nth-of-type(', '^=', '$=', '*=']

    def initialize(name, parent, locator, context)
      @name        = name
      @parent      = parent
      @locator     = locator
      @context     = context
      @type        = nil
      @alt_locator = nil
      set_locator_type
    end

    def set_locator_type(locator = nil)
      locator = @locator if locator.nil?
      is_xpath = XPATH_SELECTORS.any? { |selector| locator.include?(selector) }
      is_css = CSS_SELECTORS.any? { |selector| locator.include?(selector) }
      @locator_type = if is_xpath && !is_css
                        :xpath
                      elsif is_css && !is_xpath
                        :css
                      elsif !is_css && !is_xpath
                        :css
                      else
                        :css
                      end
    end

    def get_object_type
      if @type
        @type
      else
        obj, type = find_element
        object_not_found_exception(obj, type)
        if obj.tag_name
          obj.tag_name
        elsif obj.native.attribute('type')
          obj.native.attribute('type')
        end
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
      obj, type = find_element
      object_not_found_exception(obj, type)
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
      obj, type = find_element
      object_not_found_exception(obj, type)
      page.driver.browser.action.double_click(obj.native).perform
    end

    # Right-click on an object
    #
    # @example
    #   basket_item_image.right_click
    #
    def right_click
      obj, type = find_element
      object_not_found_exception(obj, type)
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
      obj, = find_element
      raise "UI #{object_ref_message} not found" unless obj
      obj.click_at(x, y)
    end

    def set(value)
      obj, type = find_element
      object_not_found_exception(obj, type)
      obj.set(value)
    end

    # Send keystrokes to this object.
    #
    # @param keys [String] keys
     # @example
    #   comment_field.send_keys(:enter)
    #
    def send_keys(*keys)
      obj, type = find_element
      object_not_found_exception(obj, type)
      obj.send_keys(*keys)
    end

    # Does UI object exists?
    #
    # @return [Boolean]
    # @example
    #   basket_link.exists?
    #
    def exists?(visible = true)
      obj, = find_object(visible)
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
      if exists && !invisible
        true
      else
        false
      end
    end

    # Is UI object hidden (not visible)?
    #
    # @return [Boolean]
    # @example
    #   remember_me_checkbox.hidden?
    #
    def hidden?
      !visible?
    end

    # Is UI object enabled?
    #
    # @return [Boolean]
    # @example
    #   login_button.enabled?
    #
    def enabled?
      !disabled?
    end

    # Is UI object disabled (not enabled)?
    #
    # @return [Boolean]
    # @example
    #   login_button.disabled?
    #
    def disabled?
      obj, type = find_element
      object_not_found_exception(obj, type)
      obj.disabled?
    end

    # Wait until the object exists, or until the specified wait time has expired. If the wait time is nil, then the wait
    # time will be Capybara.default_max_wait_time.
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
      raise "Could not find UI #{object_ref_message} after #{timeout} seconds" unless exists?
    end

    # Wait until the object no longer exists, or until the specified wait time has expired. If the wait time is nil, then
    # the wait time will be Capybara.default_max_wait_time.
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
      raise "UI #{object_ref_message} remained visible after #{timeout} seconds" if exists?
    end

    # Wait until the object is visible, or until the specified wait time has expired. If the wait time is nil, then the
    # wait time will be Capybara.default_max_wait_time.
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
      raise "Could not find UI #{object_ref_message} after #{timeout} seconds" unless visible?
    end

    # Wait until the object is hidden, or until the specified wait time has expired. If the wait time is nil, then the
    # wait time will be Capybara.default_max_wait_time.
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
      raise "UI #{object_ref_message} remained visible after #{timeout} seconds" if visible?
    end

    # Wait until the object's value equals the specified value, or until the specified wait time has expired. If the wait
    # time is nil, then the wait time will be Capybara.default_max_wait_time.
    #
    # @param value [String or Hash] value expected or comparison hash
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   card_authorized_label.wait_until_value_is('Card authorized', 5)
    #     or
    #   total_weight_field.wait_until_value_is({ greater_than: '250' }, 5)
    #
    def wait_until_value_is(value, seconds = nil)
      timeout = seconds.nil? ? Capybara.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { compare(value, get_value) }
    rescue
      raise "Value of UI #{object_ref_message} failed to equal '#{value}' after #{timeout} seconds" unless get_value == value
    end

    # Wait until the object's value changes to a different value, or until the specified wait time has expired. If the
    # wait time is nil, then the wait time will be Capybara.default_max_wait_time.
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
      raise "Value of UI #{object_ref_message} failed to change from '#{value}' after #{timeout} seconds" if get_value == value
    end

    # Return width of object.
    #
    # @return [Integer]
    # @example
    #   button_width = my_button.width
    #
    def width
      obj, type = find_element(false)
      object_not_found_exception(obj, type)
      obj.get_width
    end

    # Return height of object.
    #
    # @return [Integer]
    # @example
    #   button_height = my_button.height
    #
    def height
      obj, type = find_element(false)
      object_not_found_exception(obj, type)
      obj.get_height
    end

    # Return x coordinate of object's location.
    #
    # @return [Integer]
    # @example
    #   button_x = my_button.x
    #
    def x
      obj, type = find_element(false)
      object_not_found_exception(obj, type)
      obj.get_x
    end

    # Return y coordinate of object's location.
    #
    # @return [Integer]
    # @example
    #   button_y = my_button.y
    #
    def y
      obj, type = find_element(false)
      object_not_found_exception(obj, type)
      obj.get_y
    end

    # Is UI object displayed in browser window?
    #
    # @return [Boolean]
    # @example
    #   basket_link.displayed??
    #
    def displayed?
      obj, type = find_element(false)
      object_not_found_exception(obj, type)
      obj.displayed?
    end

    def get_value(visible = true)
      obj, type = find_element(visible)
      object_not_found_exception(obj, type)
      case obj.tag_name.downcase
      when 'input', 'select', 'textarea'
        obj.value
      else
        obj.text
      end
    end

    alias get_caption get_value

    def verify_value(expected, enqueue = false)
      actual = get_value
      enqueue ?
          ExceptionQueue.enqueue_assert_equal(expected.strip, actual.strip, "Expected UI #{object_ref_message}") :
          assert_equal(expected.strip, actual.strip, "Expected UI #{object_ref_message} to display '#{expected}' but found '#{actual}'")
    end

    alias verify_caption verify_value

    # Hover the cursor over an object
    #
    # @example
    #   basket_link.hover
    #
    def hover
      obj, type = find_element
      object_not_found_exception(obj, type)
      obj.hover
    end

    def drag_by(right_offset, down_offset)
      obj, type = find_element
      object_not_found_exception(obj, type)
      page.driver.browser.action.click_and_hold(obj.native).perform
      sleep(1)
      obj.drag_by(right_offset, down_offset)
    end

    def drag_and_drop(target, right_offset = nil, down_offset = nil)
      source, type = find_element
      object_not_found_exception(source, type)
      page.driver.browser.action.click_and_hold(source.native).perform
      sleep(1)
      target_drop, = target.find_element
      page.driver.browser.action.move_to(target_drop.native, right_offset.to_i, down_offset.to_i).release.perform
    end

    def get_attribute(attrib)
      obj, type = find_element(false)
      object_not_found_exception(obj, type)
      obj[attrib]
    end

    def get_native_attribute(attrib)
      obj, type = find_element(false)
      object_not_found_exception(obj, type)
      obj.native.attribute(attrib)
    end

    private

    def find_element(visible = true)
      wait = Selenium::WebDriver::Wait.new(timeout: Capybara.default_max_wait_time)
      wait.until { find_object(visible) }
    end

    def find_object(visible = true)
      @alt_locator.nil? ? obj_locator = @locator : obj_locator = @alt_locator
      parent_section = @context == :section && !@parent.get_locator.nil?
      parent_section ? tries ||= 2 : tries ||= 1

      if parent_section && tries > 1
        parent_locator = @parent.get_locator
        parent_locator = parent_locator.gsub('|', ' ')
        parent_locator_type = @parent.get_locator_type
        obj = page.find(parent_locator_type, parent_locator, wait: 0.01).find(@locator_type, obj_locator, wait: 0.01, visible: visible)
      else
        obj = page.find(@locator_type, obj_locator, wait: 0.01, visible: visible)
      end
      [obj, @locator_type]
    rescue
      retry if (tries -= 1) > 0
      [nil, nil]
    end

    def object_not_found_exception(obj, obj_type)
      @alt_locator.nil? ? locator = @locator : locator = @alt_locator
      obj_type.nil? ? object_type = 'Object' : object_type = obj_type
      raise ObjectNotFoundError.new("#{object_type} named '#{@name}' (#{locator}) not found") unless obj
    end

    def invalid_object_type_exception(obj, obj_type)
      unless obj.tag_name == obj_type || obj.native.attribute('type') == obj_type
        @alt_locator.nil? ? locator = @locator : locator = @alt_locator
        raise "#{locator} is not a #{obj_type} element"
      end
    end

    def invoke_siebel_popup
      obj, = find_element
      object_not_found_exception(obj, 'Siebel object')
      trigger_name = obj.native.attribute('aria-describedby').strip
      trigger = "span##{trigger_name}"
      trigger = "#{@parent.get_locator} #{trigger}" if @context == :section && !@parent.get_locator.nil?
      first(trigger).click
    end

    def object_ref_message
      "object '#{get_name}' (#{get_locator})"
    end
  end
end
