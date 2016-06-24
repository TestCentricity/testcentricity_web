require 'test/unit'

module TestCentricity
  class PageSection
    include Capybara::DSL
    include Capybara::Node::Matchers
    include Test::Unit::Assertions

    attr_reader   :locator, :context
    attr_accessor :parent

    def initialize(parent, locator, context)
      @parent = parent
      @locator = locator
      @context = context
    end

    # Define a trait for this page section.
    #
    # @param trait_name [Symbol] name of trait (as a symbol)
    # @param block [&block] trait value
    # @example
    #   trait(:section_locator)  { "//div[@class='Messaging_Applet']" }
    #   trait(:list_table_name)  { '#Messages' }
    #
    def self.trait(trait_name, &block)
      define_method(trait_name.to_s, &block)
    end

    # Declare and instantiate a generic UI Element for this page section.
    #
    # @param element_name [Symbol] name of UI object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   element :undo_record_item,  "//li[@rn='Undo Record']/a"
    #   element :basket_header,     "div.basket_header"
    #
    def self.element(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::UIElement.new(self, "#{locator}", :section);end))
    end

    # Declare and instantiate a button UI Element for this page section.
    #
    # @param element_name [Symbol] name of button object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   button :checkout_button, "button.checkout_button"
    #   button :login_button,    "//input[@id='submit_button']"
    #
    def self.button(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::Button.new(self, "#{locator}", :section);end))
    end

    # Declare and instantiate a text field UI Element for this page section.
    #
    # @param element_name [Symbol] name of text field object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   textfield :user_id_field,  "//input[@id='UserName']"
    #   textfield :password_field, "#consumer_password"
    #
    def self.textfield(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::TextField.new(self, "#{locator}", :section);end))
    end

    # Declare and instantiate a checkbox UI Element for this page section.
    #
    # @param element_name [Symbol] name of checkbox object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @param proxy [Symbol] Optional name (as a symbol) of proxy object to receive click actions
    # @example
    #   checkbox :remember_checkbox,     "//input[@id='RememberUser']"
    #   checkbox :accept_terms_checkbox, "#accept_terms_conditions", :accept_terms_label
    #
    def self.checkbox(element_name, locator, proxy = nil)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::CheckBox.new(self, "#{locator}", :section, #{proxy});end))
    end

    # Declare and instantiate a radio button UI Element for this page section.
    #
    # @param element_name [Symbol] name of radio object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @param proxy [Symbol] Optional name (as a symbol) of proxy object to receive click actions
    # @example
    #   radio :accept_terms_radio,  "//input[@id='Accept_Terms']"
    #   radio :decline_terms_radio, "#decline_terms_conditions", :decline_terms_label
    #
    def self.radio(element_name, locator, proxy = nil)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::Radio.new(self, "#{locator}", :section, #{proxy});end))
    end

    # Declare and instantiate a label UI Element for this page section.
    #
    # @param element_name [Symbol] name of label object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   label :welcome_label,      'div.Welcome'
    #   label :rollup_price_label, "//div[contains(@id, 'Rollup Item Price')]"
    #
    def self.label(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::Label.new(self, "#{locator}", :section);end))
    end

    # Declare and instantiate a link UI Element for this page section.
    #
    # @param element_name [Symbol] name of link object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   link :registration_link,    "a.account-nav__link.register"
    #   link :shopping_basket_link, "//a[@href='shopping_basket']"
    #
    def self.link(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::Link.new(self, "#{locator}", :section);end))
    end

    # Declare and instantiate a table UI Element for this page section.
    #
    # @param element_name [Symbol] name of table object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   table :payments_table, "//table[@class='payments_table']"
    #
    def self.table(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::Table.new(self, "#{locator}", :section);end))
    end

    # Declare and instantiate a select list UI Element for this page section.
    #
    # @param element_name [Symbol] name of select list object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   selectlist :category_selector, "#search_form_category_chosen"
    #   selectlist :gender_select,     "//select[@id='customer_gender']"
    #
    def self.selectlist(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::SelectList.new(self, "#{locator}", :section);end))
    end

    # Declare and instantiate a list UI Element for this page section.
    #
    # @param element_name [Symbol] name of list object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   list :y_axis_list, 'g.y_axis'
    #
    def self.list(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::List.new(self, "#{locator}", :section);end))
    end

    # Declare and instantiate an image UI Element for this page section.
    #
    # @param element_name [Symbol] name of image object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   image :basket_item_image,    "div.product_image"
    #   image :corporate_logo_image, "//img[@alt='MyCompany_logo']"
    #
    def self.image(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::Image.new(self, "#{locator}", :section);end))
    end

    # Declare and instantiate a File Field UI Element for this page section.
    #
    # @param element_name [Symbol] name of file field object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   filefield :attach_file, "s_SweFileName"
    #
    def self.filefield(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::FileField.new(self, "#{locator}", :section);end))
    end

    # Instantiate a PageSection object within this PageSection object.
    #
    # @param section_name [Symbol] name of PageSection object (as a symbol)
    # @param class_name [String] Class name of PageSection object
    # @example
    #   section :search_form, SearchForm
    #
    def self.section(section_name, class_name, locator = nil)
      class_eval(%Q(def #{section_name.to_s};@#{section_name.to_s} ||= #{class_name.to_s}.new(self, "#{locator}", :section);end))
    end

    def get_locator
      (@locator.empty? && defined?(section_locator)) ? locator = section_locator : locator = @locator
      (@context == :section && !@parent.nil? && !@parent.get_locator.nil?) ? "#{@parent.get_locator}|#{locator}" : locator
    end

    def set_parent(parent)
      @parent = parent
    end

    # Does Section object exists?
    #
    # @return [Boolean]
    # @example
    #   navigation_toolbar.exists?
    #
    def exists?
      section, _ = find_section
      section != nil
    end

    # Is Section object visible?
    #
    # @return [Boolean]
    # @example
    #   navigation_toolbar.visible?
    #
    def visible?
      section, _ = find_section
      exists = section
      visible = false
      visible = section.visible? if exists
      # the section is visible if it exists and it is not invisible
      (exists && visible) ? true : false
    end

    # Is Section object hidden (not visible)?
    #
    # @return [Boolean]
    # @example
    #   navigation_toolbar.hidden?
    #
    def hidden?
      not visible?
    end

    # Wait until the Section object exists, or until the specified wait time has expired.
    #
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   navigation_toolbar.wait_until_exists(0.5)
    #
    def wait_until_exists(seconds = nil)
      timeout = seconds.nil? ? Capybara.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { exists? }
    rescue
      raise "Could not find section #{get_locator} after #{timeout} seconds" unless exists?
    end

    # Wait until the Section object no longer exists, or until the specified wait time has expired.
    #
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   navigation_toolbar.wait_until_gone(5)
    #
    def wait_until_gone(seconds = nil)
      timeout = seconds.nil? ? Capybara.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { !exists? }
    rescue
      raise "Section #{get_locator} remained visible after #{timeout} seconds" if exists?
    end

    def verify_ui_states(ui_states)
      ui_states.each do | ui_object, object_states |
        object_states.each do | property, state |
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
            when :readonly
              actual = ui_object.read_only?
            when :checked
              actual = ui_object.checked?
            when :selected
              if ui_object.get_object_type == :selectlist
                actual = ui_object.get_selected_option
              else
                actual = ui_object.selected?
              end
            when :value
              actual = ui_object.get_value
            when :maxlength
              actual = ui_object.get_max_length
            when :rowcount
              actual = ui_object.get_row_count
            when :columncount
              actual = ui_object.get_column_count
            when :placeholder
              actual = ui_object.get_placeholder
            when :options
              actual = ui_object.get_options
            when :items, :list_items
              actual = ui_object.get_list_items
            when :column_headers
              actual = ui_object.get_header_columns
            when :siebel_options
              actual = ui_object.get_siebel_options
            else
              if property.to_s.start_with? ('cell_')
                cell = property.to_s.gsub('cell_', '')
                cell = cell.split('_')
                actual = ui_object.get_table_cell(cell[0].to_i, cell[1].to_i)
              elsif property.to_s.start_with? ('row_')
                row = property.to_s.gsub('row_', '')
                actual = ui_object.get_table_row(row.to_i)
              elsif property.to_s.start_with? ('column_')
                column = property.to_s.gsub('column_', '')
                actual = ui_object.get_table_column(column.to_i)
              end
          end

          if state.is_a?(Hash) && state.length == 1
            error_msg = "Expected #{ui_object.get_locator} #{property.to_s} property to"
            state.each do |key, value|
              case key
                when :lt, :less_than
                  ExceptionQueue.enqueue_exception("#{error_msg} be less than #{value} but found #{actual}") unless actual < value
                when :lt_eq, :less_than_or_equal
                  ExceptionQueue.enqueue_exception("#{error_msg} be less than or equal to #{value} but found #{actual}") unless actual <= value
                when :gt, :greater_than
                  ExceptionQueue.enqueue_exception("#{error_msg} be greater than #{value} but found #{actual}") unless actual > value
                when :gt_eq, :greater_than_or_equal
                  ExceptionQueue.enqueue_exception("#{error_msg} be greater than or equal to  #{value} but found #{actual}") unless actual >= value
                when :starts_with
                  ExceptionQueue.enqueue_exception("#{error_msg} start with '#{value}' but found #{actual}") unless actual.start_with?(value)
                when :ends_with
                  ExceptionQueue.enqueue_exception("#{error_msg} end with '#{value}' but found #{actual}") unless actual.end_with?(value)
                when :contains
                  ExceptionQueue.enqueue_exception("#{error_msg} contain '#{value}' but found #{actual}") unless actual.include?(value)
              end
            end
          else
            ExceptionQueue.enqueue_assert_equal(state, actual, "Expected #{ui_object.get_locator} #{property.to_s} property")
          end
        end
      end
      ExceptionQueue.post_exceptions
    end

    # Populate the specified UI elements in this Section object with the associated data from a Hash passed as an
    # argument. Data values must be in the form of a String for textfield and select list controls. For checkbox
    # and radio buttons, data must either be a Boolean or a String that evaluates to a Boolean value (Yes, No, 1,
    # 0, true, false)
    #
    # @param data [Hash] UI element(s) and associated data to be entered
    # @example
    #   data = { prefix_select      => 'Mr.',
    #            first_name_field   => 'Ignatious',
    #            last_name_field    => 'Snickelfritz',
    #            gender_select      => 'Male',
    #            dob_field          => '12/14/1957',
    #            organ_donor_check  => 'Yes',
    #            dnr_on_file_check  => 'Yes'
    #          }
    #   patient_record_page.personal_info_widget.populate_data_fields(data)
    #
    def populate_data_fields(data)
      data.each do | data_field, data_param |
        unless data_param.blank?
          # make sure the intended UI target element exists before trying to set its value
          data_field.wait_until_exists(2)
          if data_param == '!DELETE'
            data_field.set('')
          else
            case data_field.get_object_type
              when :checkbox
                (data_field.get_siebel_object_type == 'JCheckBox') ?
                    data_field.set_siebel_checkbox_state(data_param.to_bool) :
                    data_field.set_checkbox_state(data_param.to_bool)
              when :selectlist
                (data_field.get_siebel_object_type == 'JComboBox') ?
                    data_field.set("#{data_param}\t") :
                    data_field.choose_option(data_param)
              when :radio
                data_field.set_selected_state(data_param.to_bool)
              when :textfield
                data_field.set("#{data_param}\t")
            end
          end
        end
      end
    end

    def get_attribute(attrib)
      section, _ = find_section
      raise "Section #{locator} not found" unless section
      section[attrib]
    end

    def get_native_attribute(attrib)
      section, _ = find_section
      raise "Section #{locator} not found" unless section
      section.native.attribute(attrib)
    end

    private

    def find_section
      locator = get_locator
      tries ||= 2
      attributes = [:id, :xpath, :css]
      type = attributes[tries]
      case type
      when :css
        locator = locator.gsub('|', ' ')
      when :xpath
        locator = locator.gsub('|', '')
      end
      obj = page.find(type, locator, :wait => 0.1)
      [obj, type]
    rescue
      retry if (tries -= 1) > 0
      [nil, nil]
    end
  end
end
