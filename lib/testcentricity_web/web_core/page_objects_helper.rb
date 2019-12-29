require 'test/unit'

module TestCentricity
  class BasePageSectionObject
    include Capybara::DSL
    include Capybara::Node::Matchers
    include Test::Unit::Assertions

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
                   when :siebel_options
                     ui_object.get_siebel_options
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
                   else
                     if property.is_a?(Hash)
                       property.each do |key, value|
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
      ExceptionQueue.post_exceptions(fail_message)
    end

    # Populate the specified UI elements on this page or section object with the associated data from a Hash passed as an
    # argument. Data values must be in the form of a String for textfield and selectlist controls. For checkbox and radio
    # buttons, data must either be a Boolean or a String that evaluates to a Boolean value (Yes, No, 1, 0, true, false).
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
        unless data_param.blank?
          # make sure the intended UI target element is visible before trying to set its value
          data_field.wait_until_visible(timeout)
          if data_param == '!DELETE'
            data_field.clear
          else
            case data_field.get_object_type
            when :checkbox
              data_field.set_checkbox_state(data_param.to_bool)
            when :selectlist
              if data_field.get_siebel_object_type == 'JComboBox'
                data_field.set("#{data_param}\t")
              else
                data_field.choose_option(data_param)
              end
            when :radio
              data_field.set_selected_state(data_param.to_bool)
            when :textfield
              data_field.set("#{data_param}\t")
              if integrity_check && data_field.get_value != data_param
                data_field.set('')
                data_field.send_keys(data_param)
                data_field.send_keys(:tab)
              end
            when :section
              data_field.set(data_param)
            end
          end
        end
      end
    end
  end
end
