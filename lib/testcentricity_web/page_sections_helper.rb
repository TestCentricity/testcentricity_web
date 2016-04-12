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
    #   trait(:list_table_name)  { 'Messages' }
    #
    def self.trait(trait_name, &block)
      define_method(trait_name.to_s, &block)
    end

    # Declare and instantiate a generic UI Element for this page section.
    #
    # @param element_name [Symbol] name of UI object (as a symbol)
    # @param locator [String] css selector or xpath expression that uniquely identifies object
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
    # @param locator [String] css selector or xpath expression that uniquely identifies object
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
    # @param locator [String] css selector or xpath expression that uniquely identifies object
    # @example
    #   textfield :user_id_field,  "//input[@id='UserName']"
    #   textfield :password_field, "consumer_password"
    #
    def self.textfield(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::TextField.new(self, "#{locator}", :section);end))
    end

    # Declare and instantiate a checkbox UI Element for this page section.
    #
    # @param element_name [Symbol] name of checkbox object (as a symbol)
    # @param locator [String] css selector or xpath expression that uniquely identifies object
    # @example
    #   checkbox :remember_checkbox,     "//input[@id='RememberUser']"
    #   checkbox :accept_terms_checkbox, "accept_terms_conditions"
    #
    def self.checkbox(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::CheckBox.new(self, "#{locator}", :section);end))
    end

    # Declare and instantiate a radio button UI Element for this page section.
    #
    # @param element_name [Symbol] name of radio object (as a symbol)
    # @param locator [String] css selector or xpath expression that uniquely identifies object
    # @example
    #   radio :accept_terms_radio,  "//input[@id='Accept_Terms']"
    #   radio :decline_terms_radio, "decline_terms_conditions"
    #
    def self.radio(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::Radio.new(self, "#{locator}", :section);end))
    end

    # Declare and instantiate a label UI Element for this page section.
    #
    # @param element_name [Symbol] name of label object (as a symbol)
    # @param locator [String] css selector or xpath expression that uniquely identifies object
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
    # @param locator [String] css selector or xpath expression that uniquely identifies object
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
    # @param locator [String] css selector or xpath expression that uniquely identifies object
    # @example
    #   table :payments_table, "//table[@class='payments_table']"
    #
    def self.table(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::Table.new(self, "#{locator}", :section);end))
    end

    # Declare and instantiate a select list UI Element for this page section.
    #
    # @param element_name [Symbol] name of select list object (as a symbol)
    # @param locator [String] css selector or xpath expression that uniquely identifies object
    # @example
    #   selectlist :category_selector, "search_form_category_chosen"
    #   selectlist :gender_select,     "//select[@id='customer_gender']"
    #
    def self.selectlist(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::SelectList.new(self, "#{locator}", :section);end))
    end

    # Declare and instantiate an image UI Element for this page section.
    #
    # @param element_name [Symbol] name of image object (as a symbol)
    # @param locator [String] css selector or xpath expression that uniquely identifies object
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
    # @param locator [String] css selector or xpath expression that uniquely identifies object
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
      section, type = find_section
      exists = section
      invisible = false
      if type == :css
        Capybara.using_wait_time 0.1 do
          # is section itself hidden with .ui-helper-hidden class?
          self_hidden = page.has_css?("#{@locator}.ui-helper-hidden")
          # is parent of section hidden, thus hiding the section?
          parent_hidden = page.has_css?(".ui-helper-hidden > #{@locator}")
          # is grandparent of section, or any other ancestor, hidden?
          other_ancestor_hidden = page.has_css?(".ui-helper-hidden * #{@locator}")
          # if any of the above conditions are true, then section is invisible
          invisible = self_hidden || parent_hidden || other_ancestor_hidden
        end
      end
      # the section is visible if it exists and it is not invisible
      (exists && !invisible) ? true : false
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
              actual = ui_object.selected?
            when :value
              actual = ui_object.get_value
            when :maxlength
              actual = ui_object.get_max_length
            when :options
              actual = ui_object.get_options
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

    private

    def find_section
      wait = Selenium::WebDriver::Wait.new(timeout: Capybara.default_max_wait_time)
      wait.until { find_object }
    end

    def find_object
      locator = get_locator
      saved_wait_time = Capybara.default_max_wait_time
      Capybara.default_max_wait_time = 0.1
      tries ||= 2
      attributes = [:id, :xpath, :css]
      type = attributes[tries]
      case type
      when :css
        locator = locator.gsub("|", " ")
      when :xpath
        locator = locator.gsub("|//", "//")
      end
      obj = page.find(type, locator)
      [obj, type]
    rescue
      Capybara.default_max_wait_time = saved_wait_time
      retry if (tries -= 1) > 0
      [nil, nil]
    ensure
      Capybara.default_max_wait_time = saved_wait_time
    end
  end
end
