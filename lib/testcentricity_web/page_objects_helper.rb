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
    #   trait(:page_url)      { '/shopping_basket' }
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

    # Declare and instantiate a collection of generic UI Elements for this page object.
    #
    # @param element_hash [Hash] names of UI objects (as a symbol) and CSS selectors or XPath expressions that uniquely identifies objects
    # @example
    #   elements  profile_item:  'a#profile',
    #             settings_item: 'a#userPreferencesTrigger',
    #             log_out_item:  'a#logout'
    #
    def self.elements(element_hash)
      element_hash.each do |element_name, locator|
        element(element_name, locator)
      end
    end

    # Declare and instantiate a button UI Element for this page object.
    #
    # @param element_name [Symbol] name of button object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   button :checkout_button, 'button.checkout_button'
    #   button :login_button,    "//input[@id='submit_button']"
    #
    def self.button(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::Button.new(self, "#{locator}", :page);end))
    end

    # Declare and instantiate a collection of buttons for this page object.
    #
    # @param element_hash [Hash] names of buttons (as a symbol) and CSS selectors or XPath expressions that uniquely identifies buttons
    # @example
    #     buttons new_account_button:  'button#new-account',
    #             save_button:         'button#save',
    #             cancel_button:       'button#cancel'
    #
    def self.buttons(element_hash)
      element_hash.each do |element_name, locator|
        button(element_name, locator)
      end
    end

    # Declare and instantiate a text field UI Element for this page object.
    #
    # @param element_name [Symbol] name of text field object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   textfield :user_id_field,  "//input[@id='UserName']"
    #   textfield :password_field, 'consumer_password'
    #
    def self.textfield(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::TextField.new(self, "#{locator}", :page);end))
    end

    # Declare and instantiate a collection of text fields for this page object.
    #
    # @param element_hash [Hash] names of text fields (as a symbol) and CSS selectors or XPath expressions that uniquely identifies text fields
    # @example
    #       textfields  name_field:    'input#Name',
    #                   title_field:   'input#Title',
    #                   phone_field:   'input#PhoneNumber',
    #                   fax_field:     'input#FaxNumber',
    #                   email_field:   'input#Email'
    #
    def self.textfields(element_hash)
      element_hash.each do |element_name, locator|
        textfield(element_name, locator)
      end
    end

    # Declare and instantiate a checkbox UI Element for this page object.
    #
    # @param element_name [Symbol] name of checkbox object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @param proxy [Symbol] Optional name (as a symbol) of proxy object to receive click actions
    # @example
    #   checkbox :remember_checkbox,     "//input[@id='RememberUser']"
    #   checkbox :accept_terms_checkbox, 'input#accept_terms_conditions', :accept_terms_label
    #
    def self.checkbox(element_name, locator, proxy = nil)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::CheckBox.new(self, "#{locator}", :page, #{proxy});end))
    end

    # Declare and instantiate a collection of checkboxes for this page object.
    #
    # @param element_hash [Hash] names of checkboxes (as a symbol) and CSS selectors or XPath expressions that uniquely identifies checkboxes
    # @example
    #       checkboxes  hazmat_certified_check:  'input#hazmatCertified',
    #                   epa_certified_check:     'input#epaCertified',
    #                   dhs_certified_check:     'input#homelandSecurityCertified',
    #                   carb_compliant_check:    'input#carbCompliant'
    #
    def self.checkboxes(element_hash)
      element_hash.each do |element_name, locator|
        checkbox(element_name, locator)
      end
    end

    # Declare and instantiate a radio button UI Element for this page object.
    #
    # @param element_name [Symbol] name of radio object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @param proxy [Symbol] Optional name (as a symbol) of proxy object to receive click actions
    # @example
    #   radio :accept_terms_radio,  "//input[@id='Accept_Terms']"
    #   radio :decline_terms_radio, '#decline_terms_conditions', :decline_terms_label
    #
    def self.radio(element_name, locator, proxy = nil)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::Radio.new(self, "#{locator}", :page, #{proxy});end))
    end

    # Declare and instantiate a collection of radio buttons for this page object.
    #
    # @param element_hash [Hash] names of radio buttons (as a symbol) and CSS selectors or XPath expressions that uniquely identifies radio buttons
    # @example
    #       radios  visa_radio:       'input#payWithVisa',
    #               mastercard_radio: 'input#payWithMastercard',
    #               discover_radio:   'input#payWithDiscover',
    #               amex_radio:       'input#payWithAmEx'
    #
    def self.radios(element_hash)
      element_hash.each do |element_name, locator|
        radio(element_name, locator)
      end
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

    def self.labels(element_hash)
      element_hash.each do |element_name, locator|
        label(element_name, locator)
      end
    end

    # Declare and instantiate a link UI Element for this page object.
    #
    # @param element_name [Symbol] name of link object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   link :registration_link,    'a.account-nav__link.register'
    #   link :shopping_basket_link, "//a[@href='shopping_basket']"
    #
    def self.link(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::Link.new(self, "#{locator}", :page);end))
    end

    def self.links(element_hash)
      element_hash.each do |element_name, locator|
        link(element_name, locator)
      end
    end

    # Declare and instantiate a table UI Element for this page object.
    #
    # @param element_name [Symbol] name of table object (as a symbol)
    # @param locator [String] XPath expression that uniquely identifies object
    # @example
    #   table :payments_table, "//table[@class='payments_table']"
    #
    def self.table(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::Table.new(self, "#{locator}", :page);end))
    end

    def self.tables(element_hash)
      element_hash.each do |element_name, locator|
        table(element_name, locator)
      end
    end

    # Declare and instantiate a select list UI Element for this page object.
    #
    # @param element_name [Symbol] name of select list object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   selectlist :category_selector, 'select#search_form_category_chosen'
    #   selectlist :gender_select,     "//select[@id='customer_gender']"
    #
    def self.selectlist(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::SelectList.new(self, "#{locator}", :page);end))
    end

    def self.selectlists(element_hash)
      element_hash.each do |element_name, locator|
        selectlist(element_name, locator)
      end
    end

    # Declare and instantiate a list UI Element for this page object.
    #
    # @param element_name [Symbol] name of list object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   list :x_axis_list, 'g.x-axis'
    #
    def self.list(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::List.new(self, "#{locator}", :page);end))
    end

    def self.lists(element_hash)
      element_hash.each do |element_name, locator|
        list(element_name, locator)
      end
    end

    # Declare and instantiate an image UI Element for this page object.
    #
    # @param element_name [Symbol] name of image object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   image :basket_item_image,    'div.product_image'
    #   image :corporate_logo_image, "//img[@alt='MyCompany_logo']"
    #
    def self.image(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::Image.new(self, "#{locator}", :page);end))
    end

    def self.images(element_hash)
      element_hash.each do |element_name, locator|
        image(element_name, locator)
      end
    end

    # Declare and instantiate a File Field UI Element for this page object.
    #
    # @param element_name [Symbol] name of file field object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   filefield :attach_file, 's_SweFileName'
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

    def self.sections(section_hash)
      section_hash.each do |section_name, class_name|
        section(section_name, class_name)
      end
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
      raise "Page object #{self.class.name} does not have a page_locator trait defined" unless defined?(page_locator)
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
      raise "Page object #{self.class.name} does not have a page_locator trait defined" unless defined?(page_locator)
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
              actual = ui_object.selected?
            when :value, :caption
              actual = ui_object.get_value
            when :maxlength
              actual = ui_object.get_max_length
            when :rowcount
              actual = ui_object.get_row_count
            when :columncount
              actual = ui_object.get_column_count
            when :placeholder
              actual = ui_object.get_placeholder
            when :options, :items, :list_items
              actual = ui_object.get_list_items
            when :optioncount, :itemcount
              actual = ui_object.get_item_count
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
            error_msg = "Expected #{ui_object.get_locator} #{property.to_s} property to be"
            state.each do |key, value|
              case key
                when :lt, :less_than
                  ExceptionQueue.enqueue_exception("#{error_msg} less than #{value} but found #{actual}") unless actual < value
                when :lt_eq, :less_than_or_equal
                  ExceptionQueue.enqueue_exception("#{error_msg} less than or equal to #{value} but found #{actual}") unless actual <= value
                when :gt, :greater_than
                  ExceptionQueue.enqueue_exception("#{error_msg} greater than #{value} but found #{actual}") unless actual > value
                when :gt_eq, :greater_than_or_equal
                  ExceptionQueue.enqueue_exception("#{error_msg} greater than or equal to  #{value} but found #{actual}") unless actual >= value
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
    #   populate_data_fields(data)
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
