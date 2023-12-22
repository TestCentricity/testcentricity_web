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
  module Elements
    class UIElement
      include Capybara::DSL
      include Test::Unit::Assertions

      attr_reader   :parent, :locator, :context, :type, :name
      attr_accessor :alt_locator, :locator_type, :original_style
      attr_accessor :base_object
      attr_accessor :mru_object, :mru_locator, :mru_parent

      XPATH_SELECTORS = ['//', '[@', '[contains(']
      CSS_SELECTORS   = %w[# :nth-child( :first-child :last-child :nth-of-type( :first-of-type :last-of-type ^= $= *= :contains(]

      def initialize(name, parent, locator, context)
        @name = name
        @parent = parent
        @locator = locator
        @context = context
        @type = nil
        @alt_locator = nil
        @original_style = nil
        reset_mru_cache
        set_locator_type
      end

      def reset_mru_cache
        @mru_object = nil
        @mru_locator = nil
        @mru_parent = nil
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
          obj.click_at(10, 10)
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

      # Scroll the object to its top, middle, or bottom
      #
      # @param position [Symbol] :top, :bottom, :center
      # @example
      #   cue_list.scroll_to(:bottom)
      #
      def scroll_to(position)
        obj, type = find_element
        object_not_found_exception(obj, type)
        page.scroll_to(obj, align: position)
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
        !obj.nil?
      end

      # Is UI object visible?
      #
      # @return [Boolean]
      # @example
      #   remember_me_checkbox.visible?
      #
      def visible?
        obj, = find_element
        exists = obj
        # the object is visible if it exists and it is not invisible
        exists && obj.visible?
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

      # Is UI object's required attribute set?
      #
      # @return [Boolean]
      # @example
      #   first_name_field.required?
      #
      def required?
        obj, type = find_element
        object_not_found_exception(obj, type)
        state = get_attribute(:required)
        state.boolean? ? state : state == 'true'
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

      # Does UI object have the current focus?
      #
      # @return [Boolean]
      # @example
      #   first_name_field.focused?
      #
      def focused?
        obj, type = find_element(visible = :all)
        object_not_found_exception(obj, type)
        focused_obj = page.driver.browser.switch_to.active_element
        focused_obj == obj.native
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
        wait.until do
          reset_mru_cache
          exists?
        end
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
        wait.until do
          reset_mru_cache
          !exists?
        end
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
        wait.until do
          reset_mru_cache
          visible?
        end
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
        wait.until do
          reset_mru_cache
          hidden?
        end
      rescue StandardError
        if post_exception
          raise "UI #{object_ref_message} remained visible after #{timeout} seconds" if visible?
        else
          visible?
        end
      end

      # Wait until the object is enabled, or until the specified wait time has expired. If the wait time is nil, then the
      # wait time will be Capybara.default_max_wait_time.
      #
      # @param seconds [Integer or Float] wait time in seconds
      # @example
      #   run_button.wait_until_enabled(10)
      #
      def wait_until_enabled(seconds = nil, post_exception = true)
        timeout = seconds.nil? ? Capybara.default_max_wait_time : seconds
        wait = Selenium::WebDriver::Wait.new(timeout: timeout)
        wait.until do
          reset_mru_cache
          enabled?
        end
      rescue StandardError
        if post_exception
          raise "UI #{object_ref_message} remained disabled after #{timeout} seconds" unless enabled?
        else
          enabled?
        end
      end

      # Wait until the object is no longer in a busy state, or until the specified wait time has expired. If the wait time
      # is nil, then the wait time will be Capybara.default_max_wait_time.
      #
      # @param seconds [Integer or Float] wait time in seconds
      # @example
      #   login_button.wait_while_busy(10)
      #
      def wait_while_busy(seconds = nil, post_exception = true)
        timeout = seconds.nil? ? Capybara.default_max_wait_time : seconds
        wait = Selenium::WebDriver::Wait.new(timeout: timeout)
        wait.until do
          reset_mru_cache
          aria_busy?
        end
      rescue StandardError
        if post_exception
          raise "UI #{object_ref_message} remained in busy state after #{timeout} seconds" if aria_busy?
        else
          aria_busy?
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
        wait.until do
          reset_mru_cache
          compare(value, get_value)
        end
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
        wait.until do
          reset_mru_cache
          get_value != value
        end
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
        obj, type = find_element(visible = false)
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
        obj, type = find_element(visible = false)
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
        obj, type = find_element(visible = false)
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
        obj, type = find_element(visible = false)
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
        obj, type = find_element(visible = false)
        object_not_found_exception(obj, type)
        obj.displayed?
      end

      def get_value(visible = true)
        obj, type = find_element(visible)
        object_not_found_exception(obj, type)
        text = case obj.tag_name.downcase
               when 'input', 'select', 'textarea'
                 obj.value
               else
                 obj.text
               end
        text.gsub(/[[:space:]]+/, ' ').strip unless text.nil?
      end

      alias get_caption get_value
      alias caption get_value
      alias value get_value

      def verify_value(expected, enqueue = false)
        actual = get_value
        enqueue ?
          ExceptionQueue.enqueue_assert_equal(expected.strip, actual.strip, "Expected UI #{object_ref_message}") :
          assert_equal(expected.strip, actual.strip, "Expected UI #{object_ref_message} to display '#{expected}' but found '#{actual}'")
      end

      alias verify_caption verify_value

      # Hover the cursor over an object
      #
      # @param visible [Boolean, Symbol] Only find elements with the specified visibility:
      #                                    * true - only finds visible elements.
      #                                    * false - finds invisible _and_ visible elements.
      #                                    * :all - same as false; finds visible and invisible elements.
      #                                    * :hidden - only finds invisible elements.
      #                                    * :visible - same as true; only finds visible elements.
      # @example
      #   basket_link.hover
      #
      def hover(visible = true)
        obj, type = find_element(visible)
        object_not_found_exception(obj, type)
        obj.hover
      end

      # Hover at a specific location within an object
      #
      # @param x [Integer] X offset
      # @param y [Integer] Y offset
      # @param visible [Boolean, Symbol] Only find elements with the specified visibility:
      #                                    * true - only finds visible elements.
      #                                    * false - finds invisible _and_ visible elements.
      #                                    * :all - same as false; finds visible and invisible elements.
      #                                    * :hidden - only finds invisible elements.
      #                                    * :visible - same as true; only finds visible elements.
      # @example
      #   timeline_bar.hover_at(100, 5)
      #
      def hover_at(x, y, visible = true)
        obj, = find_element(visible)
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

      # Return crossorigin property
      #
      # @return crossorigin value
      # @example
      #   with_creds = media_player.crossorigin == 'use-credentials'
      #
      def crossorigin
        obj, = find_element
        object_not_found_exception(obj, @type)
        obj.native.attribute('crossorigin')
      end

      def get_attribute(attrib)
        obj, type = find_element(visible = false)
        object_not_found_exception(obj, type)
        obj[attrib]
      end

      def get_native_attribute(attrib)
        reset_mru_cache
        obj, type = find_element(visible = false)
        object_not_found_exception(obj, type)
        obj.native.attribute(attrib)
      end

      def find_element(visible = true)
        wait = Selenium::WebDriver::Wait.new(timeout: Capybara.default_max_wait_time)
        wait.until { find_object(visible) }
      end

      private

      def find_object(visible = true)
        obj_locator = @alt_locator.nil? ? @locator : @alt_locator
        parent_section = @context == :section && !@parent.get_locator.nil?
        tries ||= parent_section ? 2 : 1
        if parent_section && tries == 2
          parent_locator = @parent.get_locator
          parent_locator = parent_locator.tr('|', ' ')
          if @mru_locator == obj_locator && @mru_parent == parent_locator && !@mru_object.nil?
            return [@mru_object, @locator_type]
          end

          parent_locator_type = @parent.get_locator_type
          obj = page.find(
            parent_locator_type,
            parent_locator,
            visible: :all,
            wait: 0.01
          ).find(
            @locator_type,
            obj_locator,
            wait: 0.01,
            visible: visible
          )
        else
          return [@mru_object, @locator_type] if @mru_locator == obj_locator && !@mru_object.nil?

          obj = page.find(@locator_type, obj_locator, wait: 0.01, visible: visible)
        end
        @mru_object = obj
        @mru_locator = obj_locator
        @mru_parent = parent_locator
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

      def object_ref_message
        "object '#{get_name}' (#{get_locator})"
      end

      def compare(expected, actual)
        if expected.is_a?(Hash) && expected.length == 1
          expected.each do |key, value|
            case key
            when :lt, :less_than
              actual < value
            when :lt_eq, :less_than_or_equal
              actual <= value
            when :gt, :greater_than
              actual > value
            when :gt_eq, :greater_than_or_equal
              actual >= value
            when :starts_with
              actual.start_with?(value)
            when :ends_with
              actual.end_with?(value)
            when :contains
              actual.include?(value)
            when :not_contains, :does_not_contain
              !actual.include?(value)
            when :not_equal
              actual != value
            end
          end
        else
          expected == actual
        end
      end

      def find_component(component, component_name)
        begin
          element = @base_object.find(:css, component, visible: :all, wait: 1)
        rescue
          begin
            element = page.find(:css, component, visible: :all, wait: 2)
          rescue
            raise "Component #{component_name} (#{component}) for #{@type} named '#{@name}' (#{locator}) not found"
          end
        end
        element
      end
    end
  end
end
