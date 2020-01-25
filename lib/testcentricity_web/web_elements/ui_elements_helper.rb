# frozen_string_literal: true

require 'test/unit'

Capybara::Node::Element.class_eval do
  def click_at(x, y)
    right = x - (native.size.width / 2)
    top = y - (native.size.height / 2)
    driver.browser.action.move_to(native).move_by(right.to_i, top.to_i).click.perform
  end

  def hover_at(x, y)
    right = x - (native.size.width / 2)
    top = y - (native.size.height / 2)
    driver.browser.action.move_to(native).move_by(right.to_i, top.to_i).perform
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
    attr_accessor :alt_locator, :locator_type, :original_style

    XPATH_SELECTORS = ['//', '[@', '[contains(']
    CSS_SELECTORS   = ['#', ':nth-child(', ':first-child', ':last-child', ':nth-of-type(', ':first-of-type', ':last-of-type', '^=', '$=', '*=', ':contains(']

    def initialize(name, parent, locator, context)
      @name           = name
      @parent         = parent
      @locator        = locator
      @context        = context
      @type           = nil
      @alt_locator    = nil
      @original_style = nil
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

    def get_locator_type
      @locator_type
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
      rescue StandardError
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

    # Is UI object obscured (not currently in viewport and not clickable)?
    #
    # @return [Boolean]
    # @example
    #   buy_now_button.obscured?
    #
    def obscured?
      obj, type = find_element
      object_not_found_exception(obj, type)
      obj.obscured?
    end

    # Return a human readable representation of the UI element
    #
    # @return [String]
    # @example
    #   buy_now_button.inspect
    #
    def inspect
      obj, type = find_element
      object_not_found_exception(obj, type)
      obj.inspect
    end

    # Wait until the object exists, or until the specified wait time has expired. If the wait time is nil, then the wait
    # time will be Capybara.default_max_wait_time.
    #
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   run_button.wait_until_exists(0.5)
    #
    def wait_until_exists(seconds = nil, post_exception = true)
      timeout = seconds.nil? ? Capybara.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { exists? }
    rescue StandardError
      if post_exception
        raise "Could not find UI #{object_ref_message} after #{timeout} seconds" unless exists?
      else
        exists?
      end
    end

    # Wait until the object no longer exists, or until the specified wait time has expired. If the wait time is nil, then
    # the wait time will be Capybara.default_max_wait_time.
    #
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   logout_button.wait_until_gone(5)
    #
    def wait_until_gone(seconds = nil, post_exception = true)
      timeout = seconds.nil? ? Capybara.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { !exists? }
    rescue StandardError
      if post_exception
        raise "UI #{object_ref_message} remained visible after #{timeout} seconds" if exists?
      else
        exists?
      end
    end

    # Wait until the object is visible, or until the specified wait time has expired. If the wait time is nil, then the
    # wait time will be Capybara.default_max_wait_time.
    #
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   run_button.wait_until_visible(0.5)
    #
    def wait_until_visible(seconds = nil, post_exception = true)
      timeout = seconds.nil? ? Capybara.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { visible? }
    rescue StandardError
      if post_exception
        raise "Could not find UI #{object_ref_message} after #{timeout} seconds" unless visible?
      else
        visible?
      end
    end

    # Wait until the object is hidden, or until the specified wait time has expired. If the wait time is nil, then the
    # wait time will be Capybara.default_max_wait_time.
    #
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   run_button.wait_until_hidden(10)
    #
    def wait_until_hidden(seconds = nil, post_exception = true)
      timeout = seconds.nil? ? Capybara.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { hidden? }
    rescue StandardError
      if post_exception
        raise "UI #{object_ref_message} remained visible after #{timeout} seconds" if visible?
      else
        visible?
      end
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
    def wait_until_value_is(value, seconds = nil, post_exception = true)
      timeout = seconds.nil? ? Capybara.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { compare(value, get_value) }
    rescue StandardError
      if post_exception
        raise "Value of UI #{object_ref_message} failed to equal '#{value}' after #{timeout} seconds" unless get_value == value
      else
        get_value == value
      end
    end

    # Wait until the object's value changes to a different value, or until the specified wait time has expired. If the
    # wait time is nil, then the wait time will be Capybara.default_max_wait_time.
    #
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   basket_grand_total_label.wait_until_value_changes(5)
    #
    def wait_until_value_changes(seconds = nil, post_exception = true)
      value = get_value
      timeout = seconds.nil? ? Capybara.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { get_value != value }
    rescue StandardError
      if post_exception
        raise "Value of UI #{object_ref_message} failed to change from '#{value}' after #{timeout} seconds" if get_value == value
      else
        get_value == value
      end
    end

    # Return the number of occurrences of an object with an ambiguous locator that evaluates to multiple UI elements.
    #
    # @param visible [Boolean, Symbol] Only find elements with the specified visibility:
    #                                    * true - only finds visible elements.
    #                                    * false - finds invisible _and_ visible elements.
    #                                    * :all - same as false; finds visible and invisible elements.
    #                                    * :hidden - only finds invisible elements.
    #                                    * :visible - same as true; only finds visible elements.
    # @example
    #   num_uploads = upload_progress_bars.count(:all)
    #
    def count(visible = true)
      obj_locator = @alt_locator.nil? ? @locator : @alt_locator
      page.all(@locator_type, obj_locator, wait: 0.01, visible: visible, minimum: 0).count
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

    # Return UI object's title property
    #
    # @return [String]
    # @example
    #   buy_now_button.title
    #
    def title
      get_attribute(:title)
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

    # Hover at a specific location within an object
    #
    # @param x [Integer] X offset
    # @param y [Integer] Y offset
    # @example
    #   timeline_bar.hover_at(100, 5)
    #
    def hover_at(x, y)
      obj, = find_element
      raise "UI #{object_ref_message} not found" unless obj
      obj.hover_at(x, y)
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

    # Highlight an object with a 3 pixel wide, red dashed border for the specified wait time.
    # If wait time is zero, then the highlight will remain until the page is refreshed
    #
    # @param duration [Integer or Float] wait time in seconds
    # @example
    #   error_message.highlight(3)
    #
    def highlight(duration = 1)
      obj, type = find_element
      object_not_found_exception(obj, type)
      # store original style so it can be reset later
      @original_style = obj.native.attribute('style')
      # style element with red border
      page.execute_script(
        'arguments[0].setAttribute(arguments[1], arguments[2])',
        obj,
        'style',
        'border: 3px solid red; border-style: dashed;'
      )
      # keep element highlighted for duration and then revert to original style
      if duration.positive?
        sleep duration
        page.execute_script(
          'arguments[0].setAttribute(arguments[1], arguments[2])',
          obj,
          'style',
          @original_style
        )
      end
    end

    # Restore a highlighted object's original style
    #
    # @example
    #   store_link.unhighlight
    #
    def unhighlight
      obj, type = find_element
      object_not_found_exception(obj, type)
      return if @original_style.nil?
      page.execute_script(
        'arguments[0].setAttribute(arguments[1], arguments[2])',
        obj,
        'style',
        @original_style
      )
    end

    # Return UI object's style property
    #
    # @return [String]
    # @example
    #   buy_now_button.style
    #
    def style
      get_attribute('style')
    end

    # Return state of UI object's role property
    #
    # @return [String]
    # @example
    #   buy_now_button.role
    #
    def role
      get_attribute('role')
    end

    # Return state of UI object's tabindex property
    #
    # @return [String]
    # @example
    #   buy_now_button.tabindex
    #
    def tabindex
      get_attribute('tabindex')
    end

    # Return state of UI object's aria-label property
    #
    # @return [String]
    # @example
    #   buy_now_button.aria_label
    #
    def aria_label
      get_attribute('aria-label')
    end

    # Return state of UI object's aria-labelledby property
    #
    # @return [String]
    # @example
    #   buy_now_button.aria_labelledby
    #
    def aria_labelledby
      get_attribute('aria-labelledby')
    end

    # Return state of UI object's aria-describedby property
    #
    # @return [String]
    # @example
    #   buy_now_button.aria_describedby
    #
    def aria_describedby
      get_attribute('aria-describedby')
    end

    # Return state of UI object's aria-live property
    #
    # @return [String]
    # @example
    #   properties_list.aria_live
    #
    def aria_live
      get_attribute('aria-live')
    end

    # Return state of UI object's aria-sort property
    #
    # @return [String]
    # @example
    #   name_column.aria_sort
    #
    def aria_sort
      get_attribute('aria-sort')
    end

    # Return state of UI object's aria-rowcount property
    #
    # @return [Integer]
    # @example
    #   user_grid.aria_rowcount
    #
    def aria_rowcount
      get_attribute('aria-rowcount')
    end

    # Return state of UI object's aria-colcount property
    #
    # @return [Integer]
    # @example
    #   user_grid.aria_colcount
    #
    def aria_colcount
      get_attribute('aria-colcount')
    end

    # Return state of UI object's aria-valuemax property
    #
    # @return [Integer]
    # @example
    #   volume_slider.aria_valuemax
    #
    def aria_valuemax
      get_attribute('aria-valuemax')
    end

    # Return state of UI object's aria-valuemin property
    #
    # @return [Integer]
    # @example
    #   volume_slider.aria_valuemin
    #
    def aria_valuemin
      get_attribute('aria-valuemin')
    end

    # Return state of UI object's aria-valuenow property
    #
    # @return [Integer]
    # @example
    #   volume_slider.aria_valuenow
    #
    def aria_valuenow
      get_attribute('aria-valuenow')
    end

    # Return state of UI object's aria-valuetext property
    #
    # @return [Integer]
    # @example
    #   volume_slider.aria_valuetext
    #
    def aria_valuetext
      get_attribute('aria-valuetext')
    end

    # Return state of UI object's aria-orientation property
    #
    # @return [Integer]
    # @example
    #   volume_slider.aria_orientation
    #
    def aria_orientation
      get_attribute('aria-orientation')
    end

    # Return state of UI object's aria-keyshortcuts property
    #
    # @return [Integer]
    # @example
    #   play_button.aria_keyshortcuts
    #
    def aria_keyshortcuts
      get_attribute('aria-keyshortcuts')
    end

    # Return state of UI object's aria-roledescription property
    #
    # @return [Integer]
    # @example
    #   editor_button.aria_roledescription
    #
    def aria_roledescription
      get_attribute('aria-roledescription')
    end

    # Return state of UI object's aria-autocomplete property
    #
    # @return [Integer]
    # @example
    #   email_field.aria_autocomplete
    #
    def aria_autocomplete
      get_attribute('aria-autocomplete')
    end

    # Return state of UI object's aria-controls property
    #
    # @return [Integer]
    # @example
    #   video_menu.aria_controls
    #
    def aria_controls
      get_attribute('aria-controls')
    end

    # Return state of UI object's aria-disabled property
    #
    # @return [Boolean]
    # @example
    #   buy_now_button.aria_disabled?
    #
    def aria_disabled?
      state = get_attribute('aria-disabled')
      state.boolean? ? state : state == 'true'
    end

    # Return state of UI object's aria-selected property
    #
    # @return [Boolean]
    # @example
    #   nutrition_info_tab.aria_selected?
    #
    def aria_selected?
      state = get_attribute('aria-selected')
      state.boolean? ? state : state == 'true'
    end

    # Return state of UI object's aria-hidden property
    #
    # @return [Boolean]
    # @example
    #   nutrition_info_tab.aria_hidden?
    #
    def aria_hidden?
      state = get_attribute('aria-hidden')
      state.boolean? ? state : state == 'true'
    end

    # Return state of UI object's aria-expanded property
    #
    # @return [Boolean]
    # @example
    #   catalog_tree.aria_expanded?
    #
    def aria_expanded?
      state = get_attribute('aria-expanded')
      state.boolean? ? state : state == 'true'
    end

    # Return state of UI object's aria-required property
    #
    # @return [Boolean]
    # @example
    #   home_phone_field.aria_required?
    #
    def aria_required?
      state = get_attribute('aria-required')
      state.boolean? ? state : state == 'true'
    end

    # Return state of UI object's aria-invalid property
    #
    # @return [Boolean]
    # @example
    #   home_phone_field.aria_invalid?
    #
    def aria_invalid?
      state = get_attribute('aria-invalid')
      state.boolean? ? state : state == 'true'
    end

    # Return state of UI object's aria-checked property
    #
    # @return [Boolean]
    # @example
    #   allow_new_users_checkbox.aria_checked?
    #
    def aria_checked?
      state = get_attribute('aria-checked')
      state.boolean? ? state : state == 'true'
    end

    # Return state of UI object's aria-haspopup property
    #
    # @return [Boolean]
    # @example
    #   user_avatar.aria_haspopup?
    #
    def aria_haspopup?
      state = get_attribute('aria-haspopup')
      state.boolean? ? state : state == 'true'
    end

    # Return state of UI object's aria-pressed property
    #
    # @return [Boolean]
    # @example
    #   option1_button.aria_pressed?
    #
    def aria_pressed?
      state = get_attribute('aria-pressed')
      state.boolean? ? state : state == 'true'
    end

    # Return state of UI object's aria-readonly property
    #
    # @return [Boolean]
    # @example
    #   home_phone_field.aria_readonly?
    #
    def aria_readonly?
      state = get_attribute('aria-readonly')
      state.boolean? ? state : state == 'true'
    end

    # Return state of UI object's aria-busy property
    #
    # @return [Boolean]
    # @example
    #   home_phone_field.aria_busy?
    #
    def aria_busy?
      state = get_attribute('aria-busy')
      state.boolean? ? state : state == 'true'
    end

    # Return state of UI object's aria-modal property
    #
    # @return [Boolean]
    # @example
    #   add_user_modal.aria_modal?
    #
    def aria_modal?
      state = get_attribute('aria-modal')
      state.boolean? ? state : state == 'true'
    end

    # Return state of UI object's aria-multiline property
    #
    # @return [Boolean]
    # @example
    #   description_field.aria_multiline?
    #
    def aria_multiline?
      state = get_attribute('aria-multiline')
      state.boolean? ? state : state == 'true'
    end

    # Return state of UI object's aria-multiselectable property
    #
    # @return [Boolean]
    # @example
    #   channels_select.aria_multiselectable?
    #
    def aria_multiselectable?
      state = get_attribute('aria-multiselectable')
      state.boolean? ? state : state == 'true'
    end

    # Return state of UI object's contenteditable property
    #
    # @return [Boolean]
    # @example
    #   description_field.content_editable?
    #
    def content_editable?
      state = get_attribute('contenteditable')
      state.boolean? ? state : state == 'true'
    end

    def get_attribute(attrib)
      obj, type = find_element(visible = false)
      object_not_found_exception(obj, type)
      obj[attrib]
    end

    def get_native_attribute(attrib)
      obj, type = find_element(visible = false)
      object_not_found_exception(obj, type)
      obj.native.attribute(attrib)
    end

    private

    def find_element(visible = true)
      wait = Selenium::WebDriver::Wait.new(timeout: Capybara.default_max_wait_time)
      wait.until { find_object(visible) }
    end

    def find_object(visible = true)
      obj_locator = @alt_locator.nil? ? @locator : @alt_locator
      parent_section = @context == :section && !@parent.get_locator.nil?
      tries ||= parent_section ? 2 : 1
      if parent_section && tries == 2
        parent_locator = @parent.get_locator
        parent_locator = parent_locator.tr('|', ' ')
        parent_locator_type = @parent.get_locator_type
        obj = page.find(parent_locator_type, parent_locator, visible: :all, wait: 0.01).find(@locator_type, obj_locator, wait: 0.01, visible: visible)
      else
        obj = page.find(@locator_type, obj_locator, wait: 0.01, visible: visible)
      end
      [obj, @locator_type]
    rescue StandardError
      retry if (tries -= 1).positive?
      [nil, nil]
    end

    def object_not_found_exception(obj, obj_type)
      locator = @alt_locator.nil? ? @locator : @alt_locator
      object_type = obj_type.nil? ? 'Object' : obj_type
      raise ObjectNotFoundError, "#{object_type} named '#{@name}' (#{locator}) not found" unless obj
    end

    def invalid_object_type_exception(obj, obj_type)
      unless obj.tag_name == obj_type || obj.native.attribute('type') == obj_type
        locator = @alt_locator.nil? ? @locator : @alt_locator
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
