require 'test/unit'

module TestCentricity
  class PageObject
    include Capybara::DSL
    include Capybara::Node::Matchers
    include Test::Unit::Assertions

    # Define a trait for this page object.
    #
    # @param trait_name [Symbol] name of trait (as a symbol)
    # @param block [&block] trait value
    # @example
    #   trait(:page_name)     { 'Shopping Basket' }
    #   trait(:page_url)      { "/shopping_basket" }
    #   trait(:page_locator)  { "//body[@class='shopping_baskets']" }
    #
    def self.trait(trait_name, &block)
      define_method(trait_name.to_s, &block)
    end

    # Declare and instantiate a generic UI Element for this page object.
    #
    # @param element_name [Symbol] name of UI object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   element :siebel_view,  'div#_sweview'
    #   element :siebel_busy,  "//html[contains(@class, 'siebui-busy')]"
    #
    def self.element(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::UIElement.new(self, "#{locator}", :page);end))
    end

    # Declare and instantiate a button UI Element for this page object.
    #
    # @param element_name [Symbol] name of button object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   button :checkout_button, "button.checkout_button"
    #   button :login_button,    "//input[@id='submit_button']"
    #
    def self.button(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::Button.new(self, "#{locator}", :page);end))
    end

    # Declare and instantiate a text field UI Element for this page object.
    #
    # @param element_name [Symbol] name of text field object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   textfield :user_id_field,  "//input[@id='UserName']"
    #   textfield :password_field, "consumer_password"
    #
    def self.textfield(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::TextField.new(self, "#{locator}", :page);end))
    end

    # Declare and instantiate a checkbox UI Element for this page object.
    #
    # @param element_name [Symbol] name of checkbox object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @param proxy [Symbol] Optional name (as a symbol) of proxy object to receive click actions
    # @example
    #   checkbox :remember_checkbox,     "//input[@id='RememberUser']"
    #   checkbox :accept_terms_checkbox, "#accept_terms_conditions", :accept_terms_label
    #
    def self.checkbox(element_name, locator, proxy = nil)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::CheckBox.new(self, "#{locator}", :page, #{proxy});end))
    end

    # Declare and instantiate a radio button UI Element for this page object.
    #
    # @param element_name [Symbol] name of radio object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @param proxy [Symbol] Optional name (as a symbol) of proxy object to receive click actions
    # @example
    #   radio :accept_terms_radio,  "//input[@id='Accept_Terms']"
    #   radio :decline_terms_radio, "#decline_terms_conditions", :decline_terms_label
    #
    def self.radio(element_name, locator, proxy = nil)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::Radio.new(self, "#{locator}", :page, #{proxy});end))
    end

    # Declare and instantiate a label UI Element for this page object.
    #
    # @param element_name [Symbol] name of label object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   label :welcome_label,      'div.Welcome'
    #   label :rollup_price_label, "//div[contains(@id, 'Rollup Item Price')]"
    #
    def self.label(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::Label.new(self, "#{locator}", :page);end))
    end

    # Declare and instantiate a link UI Element for this page object.
    #
    # @param element_name [Symbol] name of link object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   link :registration_link,    "a.account-nav__link.register"
    #   link :shopping_basket_link, "//a[@href='shopping_basket']"
    #
    def self.link(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::Link.new(self, "#{locator}", :page);end))
    end

    # Declare and instantiate a table UI Element for this page object.
    #
    # @param element_name [Symbol] name of table object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   table :payments_table, "//table[@class='payments_table']"
    #
    def self.table(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::Table.new(self, "#{locator}", :page);end))
    end

    # Declare and instantiate a select list UI Element for this page object.
    #
    # @param element_name [Symbol] name of select list object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   selectlist :category_selector, "#search_form_category_chosen"
    #   selectlist :gender_select,     "//select[@id='customer_gender']"
    #
    def self.selectlist(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::SelectList.new(self, "#{locator}", :page);end))
    end

    # Declare and instantiate an image UI Element for this page object.
    #
    # @param element_name [Symbol] name of image object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   image :basket_item_image,    "div.product_image"
    #   image :corporate_logo_image, "//img[@alt='MyCompany_logo']"
    #
    def self.image(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::Image.new(self, "#{locator}", :page);end))
    end

    # Declare and instantiate a File Field UI Element for this page object.
    #
    # @param element_name [Symbol] name of file field object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   filefield :attach_file, "s_SweFileName"
    #
    def self.filefield(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::FileField.new(self, "#{locator}", :page);end))
    end

    # Instantiate a PageSection object for this page object.
    #
    # @param section_name [Symbol] name of PageSection object (as a symbol)
    # @param class_name [String] Class name of PageSection object
    # @example
    #   section :search_form, SearchForm
    #
    def self.section(section_name, class_name, locator = nil)
      class_eval(%Q(def #{section_name.to_s};@#{section_name.to_s} ||= #{class_name.to_s}.new(self, "#{locator}", :page);end))
    end

    def open_portal
      environment = Environ.current
      environment.hostname.blank? ?
          url = "#{environment.base_url}#{environment.append}" :
          url = "#{environment.hostname}/#{environment.base_url}#{environment.append}"
      if environment.user_id.blank? || environment.password.blank?
        visit "#{environment.protocol}://#{url}"
      else
        visit "#{environment.protocol}://#{environment.user_id}:#{environment.password}@#{url}"
      end
      Environ.set_portal_state(:open)
    end

    def verify_page_exists
      unless page.has_selector?(page_locator)
        body_class = find(:xpath, '//body')[:class]
        error_message = "Expected page to have selector '#{page_locator}' but found '#{body_class}' instead.\nURL of page loaded = #{URI.parse(current_url)}"
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
      PageManager.set_current_page(self)
    end

    def verify_page_contains(content)
      raise "Expected page to have content '#{content}'" unless page.has_content?(:visible, content)
    end

    # Does Page object exists?
    #
    # @return [Boolean]
    # @example
    #   home_page.exists?
    #
    def exists?
      saved_wait_time = Capybara.default_max_wait_time
      Capybara.default_max_wait_time = 0.1
      tries ||= 2
      attributes = [:id, :css, :xpath]
      type = attributes[tries]
      obj = page.find(type, page_locator)
      obj != nil
    rescue
      Capybara.default_max_wait_time = saved_wait_time
      retry if (tries -= 1) > 0
      false
    ensure
      Capybara.default_max_wait_time = saved_wait_time
    end

    # Is current Page object URL secure?
    #
    # @return [Boolean]
    # @example
    #   home_page.secure?
    #
    def secure?
      !current_url.match(/^https/).nil?
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
            when :column_headers
              actual = ui_object.get_header_columns
            when :siebel_options
              actual = ui_object.get_siebel_options
            else
              if property.to_s.start_with? ('cell_')
                cell = property.to_s.gsub('cell_', '')
                cell = cell.split('_')
                actual = ui_object.get_table_cell(cell[0].to_i, cell[1].to_i)
              end
          end
          ExceptionQueue.enqueue_assert_equal(state, actual, "Expected #{ui_object.get_locator} #{property.to_s} property")
        end
      end
      ExceptionQueue.post_exceptions
    end

    # Populate the specified UI elements on this page with the associated data from a Hash passed as an argument. Data
    # values must be in the form of a String for textfield and select list controls. For checkbox and radio buttons,
    # data must either be a Boolean or a String that evaluates to a Boolean value (Yes, No, 1, 0, true, false)
    #
    # @param data [Hash] UI element(s) and associated data to be entered
    # @example
    #   data = { prefix_select      => 'Ms',
    #            first_name_field   => 'Priscilla',
    #            last_name_field    => 'Pumperknickle',
    #            gender_select      => 'Female',
    #            dob_field          => '11/18/1976',
    #            email_field        => 'p.pumperknickle4876@google.com',
    #            mailing_list_check => 'Yes'
    #          }
    #   registration_page.populate_data_fields(data)
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
  end
end
