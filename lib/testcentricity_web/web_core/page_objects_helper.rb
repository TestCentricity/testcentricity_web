require 'test/unit'

module TestCentricity
  class BasePageSectionObject
    include Capybara::DSL
    include Capybara::Node::Matchers
    include Test::Unit::Assertions

    attr_accessor :locator_type

    XPATH_SELECTORS = ['//', '[@', '[contains(']
    CSS_SELECTORS   = %w[# :nth-child( :first-child :last-child :nth-of-type( :first-of-type :last-of-type ^= $= *= :contains(]

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

    # Define a trait for this page or section object.
    #
    # @param trait_name [Symbol] name of trait (as a symbol)
    # @param block [&block] trait value
    # @example
    #   trait(:page_name)        { 'Shopping Basket' }
    #   trait(:page_url)         { '/shopping_basket' }
    #   trait(:page_locator)     { "//body[@class='shopping_baskets']" }
    #   trait(:section_locator)  { "//div[@class='Messaging_Applet']" }
    #   trait(:list_table_name)  { '#Messages' }
    #
    def self.trait(trait_name, &block)
      define_method(trait_name.to_s, &block)
    end

    def verify_ui_states(ui_states, fail_message = nil)
      ui_states.each do |ui_object, object_states|
        object_states.each do |property, state|
          actual = case property
                   when :class
                     ui_object.get_attribute(:class)
                   when :name
                     ui_object.get_attribute(:name)
                   when :title
                     ui_object.title
                   when :secure
                     ui_object.secure?
                   when :exists
                     ui_object.exists?
                   when :enabled
                     ui_object.enabled?
                   when :disabled
                     ui_object.disabled?
                   when :visible
                     ui_object.visible?
                   when :hidden
                     ui_object.hidden?
                   when :displayed
                     ui_object.displayed?
                   when :obscured
                     ui_object.obscured?
                   when :focused
                     ui_object.focused?
                   when :width
                     ui_object.width
                   when :height
                     ui_object.height
                   when :x
                     ui_object.x
                   when :y
                     ui_object.y
                   when :readonly
                     ui_object.read_only?
                   when :checked
                     ui_object.checked?
                   when :selected
                     ui_object.selected?
                   when :indeterminate
                     ui_object.indeterminate?
                   when :value, :caption
                     ui_object.get_value
                   when :required
                     ui_object.required?
                   when :maxlength
                     ui_object.get_max_length
                   when :rowcount
                     ui_object.get_row_count
                   when :columncount
                     ui_object.get_column_count
                   when :placeholder
                     ui_object.get_placeholder
                   when :min
                     ui_object.get_min
                   when :max
                     ui_object.get_max
                   when :step
                     ui_object.get_step
                   when :loaded
                     ui_object.loaded?
                   when :broken
                     ui_object.broken?
                   when :alt
                     ui_object.alt
                   when :src
                     ui_object.src
                   when :autoplay
                     ui_object.autoplay?
                   when :ended
                     ui_object.ended?
                   when :controls
                     ui_object.controls?
                   when :loop
                     ui_object.loop?
                   when :muted
                     ui_object.muted?
                   when :default_muted
                     ui_object.default_muted?
                   when :paused
                     ui_object.paused?
                   when :seeking
                     ui_object.seeking?
                   when :current_time
                     ui_object.current_time
                   when :default_playback_rate
                     ui_object.default_playback_rate
                   when :duration
                     ui_object.duration
                   when :playback_rate
                     ui_object.playback_rate
                   when :ready_state
                     ui_object.ready_state
                   when :volume
                     ui_object.volume
                   when :track_count
                     ui_object.track_count
                   when :active_track
                     ui_object.active_track
                   when :active_track_data
                     ui_object.active_track_data
                   when :active_track_source
                     ui_object.active_track_source
                   when :all_tracks_data
                     ui_object.all_tracks_data
                   when :crossorigin
                     ui_object.crossorigin
                   when :preload
                     ui_object.preload
                   when :poster
                     ui_object.poster
                   when :options, :items, :list_items
                     ui_object.get_list_items
                   when :optioncount, :itemcount
                     ui_object.get_item_count
                   when :groupcount
                     ui_object.get_group_count
                   when :group_headings
                     ui_object.get_group_headings
                   when :all_items, :all_list_items
                     ui_object.get_all_list_items
                   when :all_items_count
                     ui_object.get_all_items_count
                   when :column_headers
                     ui_object.get_header_columns
                   when :count, :count_visible
                     ui_object.count(visible = true)
                   when :count_all
                     ui_object.count(visible = :all)
                   when :style
                     ui_object.style
                   when :href
                     ui_object.href
                   when :role
                     ui_object.role
                   when :aria_label
                     ui_object.aria_label
                   when :aria_disabled
                     ui_object.aria_disabled?
                   when :tabindex
                     ui_object.tabindex
                   when :aria_labelledby
                     ui_object.aria_labelledby
                   when :aria_describedby
                     ui_object.aria_describedby
                   when :aria_live
                     ui_object.aria_live
                   when :aria_busy
                     ui_object.aria_busy?
                   when :aria_selected
                     ui_object.aria_selected?
                   when :aria_hidden
                     ui_object.aria_hidden?
                   when :aria_expanded
                     ui_object.aria_expanded?
                   when :aria_required
                     ui_object.aria_required?
                   when :aria_invalid
                     ui_object.aria_invalid?
                   when :aria_checked
                     ui_object.aria_checked?
                   when :aria_readonly
                     ui_object.aria_readonly?
                   when :aria_pressed
                     ui_object.aria_pressed?
                   when :aria_haspopup
                     ui_object.aria_haspopup?
                   when :aria_sort
                     ui_object.aria_sort
                   when :aria_rowcount
                     ui_object.aria_rowcount
                   when :aria_colcount
                     ui_object.aria_colcount
                   when :aria_valuemax
                     ui_object.aria_valuemax
                   when :aria_valuemin
                     ui_object.aria_valuemin
                   when :aria_valuenow
                     ui_object.aria_valuenow
                   when :aria_valuetext
                     ui_object.aria_valuetext
                   when :aria_orientation
                     ui_object.aria_orientation
                   when :aria_keyshortcuts
                     ui_object.aria_keyshortcuts
                   when :aria_roledescription
                     ui_object.aria_roledescription
                   when :aria_autocomplete
                     ui_object.aria_autocomplete
                   when :aria_controls
                     ui_object.aria_controls
                   when :aria_modal
                     ui_object.aria_modal?
                   when :aria_multiline
                     ui_object.aria_multiline?
                   when :aria_multiselectable
                     ui_object.aria_multiselectable?
                   when :content_editable
                     ui_object.content_editable?
                   when :validation_message
                     ui_object.validation_message
                   when :badInput
                     ui_object.validity?(:badInput)
                   when :customError
                     ui_object.validity?(:customError)
                   when :patternMismatch
                     ui_object.validity?(:patternMismatch)
                   when :rangeOverflow
                     ui_object.validity?(:rangeOverflow)
                   when :rangeUnderflow
                     ui_object.validity?(:rangeUnderflow)
                   when :stepMismatch
                     ui_object.validity?(:stepMismatch)
                   when :tooLong
                     ui_object.validity?(:tooLong)
                   when :tooShort
                     ui_object.validity?(:tooShort)
                   when :typeMismatch
                     ui_object.validity?(:typeMismatch)
                   when :valid
                     ui_object.validity?(:valid)
                   when :valueMissing
                     ui_object.validity?(:valueMissing)
                   else
                     if property.is_a?(Hash)
                       property.map do |key, value|
                         case key
                         when :cell
                           ui_object.get_table_cell(value[0].to_i, value[1].to_i)
                         when :row
                           ui_object.get_table_row(value.to_i)
                         when :column
                           ui_object.get_table_column(value.to_i)
                         when :item
                           ui_object.get_list_item(value.to_i)
                         when :attribute
                           ui_object.get_attribute(value)
                         when :native_attribute
                           ui_object.get_native_attribute(value)
                         end
                       end
                     end
                   end
          error_msg = if ui_object.respond_to?(:get_name)
                        "Expected UI object '#{ui_object.get_name}' (#{ui_object.get_locator}) #{property} property to"
                      else
                        "Expected '#{page_name}' page object #{property} property to"
                      end
          ExceptionQueue.enqueue_comparison(ui_object, state, actual, error_msg)
        end
      end
    rescue ObjectNotFoundError => e
      ExceptionQueue.enqueue_exception(e.message)
    ensure
      error_msg = "#{fail_message}\nPage URL = #{URI.parse(current_url)}"
      ExceptionQueue.post_exceptions(error_msg)
    end

    # Populate the specified UI elements on this page or section object with the associated data from a Hash passed as an
    # argument. Data values must be in the form of a String for textfield, selectlist, and filefield controls. For checkbox
    # and radio buttons, data must either be a Boolean or a String that evaluates to a Boolean value (Yes, No, 1, 0, true,
    # false). For range controls, data must be an Integer. For input(type='color') color picker controls, which are specified
    # as a textfield, data must be in the form of a hex color String. For section objects, data values must be a String, and
    # the section object must have a set method defined.
    #
    # The optional wait_time parameter is used to specify the time (in seconds) to wait for each UI element to become
    # visible before entering the associated data value. This option is useful in situations where entering data, or
    # setting the state of a UI element might cause other UI elements to become visible or active. Specifying a wait_time
    # value ensures that the subsequent UI elements will be ready to be interacted with as states are changed. If the wait
    # time is nil, then the wait time will be 5 seconds.
    #
    # To delete all text content in a text field, pass !DELETE as the data to be entered.
    #
    # @param data [Hash] UI element(s) and associated data to be entered
    # @param wait_time [Integer] wait time in seconds
    # @param integrity_check [Boolean] if TRUE, ensure that text entered into text fields matches what was entered
    # @example
    #   field_data = { prefix_select      => 'Ms',
    #                  first_name_field   => 'Priscilla',
    #                  last_name_field    => 'Pumperknickle',
    #                  gender_select      => 'Female',
    #                  dob_field          => '11/18/1976',
    #                  email_field        => 'p.pumperknickle4876@gmail.com',
    #                  mailing_list_check => 'Yes'
    #          }
    #   populate_data_fields(field_data)
    #
    def populate_data_fields(data, wait_time = nil, integrity_check = false)
      timeout = wait_time.nil? ? 5 : wait_time
      data.each do |data_field, data_param|
        unless data_param != false && data_param.blank?
          # make sure the intended UI target element is visible before trying to set its value
          data_field.wait_until_visible(timeout)
          if data_param == '!DELETE'
            data_field.clear
          else
            case data_field.get_object_type
            when :checkbox
              check_state = data_param.is_a?(String) ? data_param.to_bool : data_param
              data_field.set_checkbox_state(check_state)
            when :selectlist
              data_field.choose_option(data_param)
            when :radio
              check_state = data_param.is_a?(String) ? data_param.to_bool : data_param
              data_field.set_selected_state(check_state)
            when :textfield
              if %w[color number].include?(data_field.get_attribute(:type))
                data_field.set(data_param)
              else
                data_field.set("#{data_param}\t")
                if integrity_check && data_field.get_value != data_param
                  data_field.set('')
                  data_field.send_keys(data_param)
                  data_field.send_keys(:tab)
                end
              end
            when :section, :range
              data_field.set(data_param)
            when :filefield
              data_field.file_upload(data_param)
            end
          end
        end
      end
    end

    def verify_focus_order(order)
      order.each do |expected_element|
        if expected_element.is_a?(Array)
          expected_element.each do |sub_element|
            set_verify_focus(:arrow_right, sub_element)
          end
        else
          set_verify_focus(:tab, expected_element)
        end
      end
    end

    private

    def set_verify_focus(key, expected_element)
      page.driver.browser.action.send_keys(key).perform
      sleep(0.5)
      focused_obj = page.driver.browser.switch_to.active_element
      expected_element.reset_mru_cache
      expected_obj, = expected_element.find_element(visible = :all)
      unless focused_obj == expected_obj.native
        raise "Expected element '#{expected_element.get_name}' to have focus but found '#{focused_obj[:id]} is focused instead'"
      end

      puts "Element '#{expected_element.get_name}' is focused as expected"
      end
  end
end
