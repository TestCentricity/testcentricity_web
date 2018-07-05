require 'test/unit'

module TestCentricity
  class PageSection
    include Capybara::DSL
    include Capybara::Node::Matchers
    include Test::Unit::Assertions

    attr_reader   :context, :name
    attr_accessor :locator
    attr_accessor :parent
    attr_accessor :parent_list
    attr_accessor :list_index
    attr_accessor :locator_type

    XPATH_SELECTORS = ['//', '[@', '[contains(@']
    CSS_SELECTORS   = ['#', ':nth-child(', ':nth-of-type(', '^=', '$=', '*=']

    def initialize(name, parent, locator, context)
      @name         = name
      @parent       = parent
      @locator      = locator
      @context      = context
      @parent_list  = nil
      @list_index   = nil

      is_xpath = XPATH_SELECTORS.any? { |selector| @locator.include?(selector) }
      is_css = CSS_SELECTORS.any? { |selector| @locator.include?(selector) }
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

    def get_locator
      if @locator.empty? && defined?(section_locator)
        locator = section_locator
      else
        locator = @locator
      end

      unless @parent_list.nil?
        locator = "#{@parent_list.get_locator}|#{locator}"
        unless @list_index.nil?
          case @locator_type
            when :xpath
              locator = "(#{locator})[#{@list_index}]"
            when :css
              locator = "#{locator}:nth-of-type(#{@list_index})"
          end
        end
      end

      if @context == :section && !@parent.nil? && !@parent.get_locator.nil?
        "#{@parent.get_locator}|#{locator}"
      else
        locator
      end
    end

    def get_locator_type
      @locator_type
    end

    def set_list_index(list, index = 1)
      @parent_list = list unless list.nil?
      @list_index  = index
    end

    def get_item_count
      raise 'No parent list defined' if @parent_list.nil?
      @parent_list.get_item_count
    end

    def get_list_items
      items = []
      (1..get_item_count).each do |item|
        set_list_index(nil, item)
        items.push(get_value)
      end
      items
    end

    def get_all_items_count
      raise 'No parent list defined' if @parent_list.nil?
      @parent_list.get_all_items_count
    end

    def get_all_list_items
      items = []
      (1..get_all_items_count).each do |item|
        set_list_index(nil, item)
        items.push(get_value(:all))
      end
      items
    end

    def verify_list_items(expected, enqueue = false)
      actual = get_list_items
      enqueue ?
          ExceptionQueue.enqueue_assert_equal(expected, actual, "Expected list '#{get_name}' (#{get_locator})") :
          assert_equal(expected, actual, "Expected list object '#{get_name}' (#{get_locator}) to be #{expected} but found #{actual}")
    end

    def get_object_type
      :section
    end

    def get_name
      @name
    end

    def set_parent(parent)
      @parent = parent
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

    # Declare and instantiate a single generic UI Element for this page section.
    #
    # @param element_name [Symbol] name of UI object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   element :undo_record_item,  "//li[@rn='Undo Record']/a"
    #   element :basket_header,     'div.basket_header'
    #
    def self.element(element_name, locator)
      define_element(element_name, TestCentricity::UIElement, locator)
    end

    # Declare and instantiate a collection of generic UI Elements for this page section.
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

    # Declare and instantiate a single button UI Element for this page section.
    #
    # @param element_name [Symbol] name of button object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   button :checkout_button, 'button.checkout_button'
    #   button :login_button,    "//input[@id='submit_button']"
    #
    def self.button(element_name, locator)
      define_element(element_name, TestCentricity::Button, locator)
    end

    # Declare and instantiate a collection of buttons for this page section.
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

    # Declare and instantiate a single text field UI Element for this page section.
    #
    # @param element_name [Symbol] name of text field object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   textfield :user_id_field,  "//input[@id='UserName']"
    #   textfield :password_field, 'input#consumer_password'
    #
    def self.textfield(element_name, locator)
      define_element(element_name, TestCentricity::TextField, locator)
    end

    # Declare and instantiate a collection of text fields for this page section.
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

    # Declare and instantiate a single checkbox UI Element for this page section.
    #
    # @param element_name [Symbol] name of checkbox object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @param proxy [Symbol] Optional name (as a symbol) of proxy object to receive click actions
    # @example
    #   checkbox :remember_checkbox,     "//input[@id='RememberUser']"
    #   checkbox :accept_terms_checkbox, 'input#accept_terms_conditions', :accept_terms_label
    #
    def self.checkbox(element_name, locator, proxy = nil)
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::CheckBox.new("#{element_name}", self, "#{locator}", :section, #{proxy});end))
    end

    # Declare and instantiate a collection of checkboxes for this page section.
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

    # Declare and instantiate a single radio button UI Element for this page section.
    #
    # @param element_name [Symbol] name of radio object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @param proxy [Symbol] Optional name (as a symbol) of proxy object to receive click actions
    # @example
    #   radio :accept_terms_radio,  "//input[@id='Accept_Terms']"
    #   radio :decline_terms_radio, 'input#decline_terms_conditions', :decline_terms_label
    #
    def self.radio(element_name, locator, proxy = nil)
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::Radio.new("#{element_name}", self, "#{locator}", :section, #{proxy});end))
    end

    # Declare and instantiate a collection of radio buttons for this page section.
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

    # Declare and instantiate a single label UI Element for this page section.
    #
    # @param element_name [Symbol] name of label object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   label :welcome_label,      'div.Welcome'
    #   label :rollup_price_label, "//div[contains(@id, 'Rollup Item Price')]"
    #
    def self.label(element_name, locator)
      define_element(element_name, TestCentricity::Label, locator)
    end

    def self.labels(element_hash)
      element_hash.each do |element_name, locator|
        label(element_name, locator)
      end
    end

    # Declare and instantiate a single link UI Element for this page section.
    #
    # @param element_name [Symbol] name of link object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   link :registration_link,    'a.account-nav__link.register'
    #   link :shopping_basket_link, "//a[@href='shopping_basket']"
    #
    def self.link(element_name, locator)
      define_element(element_name, TestCentricity::Link, locator)
    end

    def self.links(element_hash)
      element_hash.each do |element_name, locator|
        link(element_name, locator)
      end
    end

    # Declare and instantiate a single table UI Element for this page section.
    #
    # @param element_name [Symbol] name of table object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   table :payments_table, "//table[@class='payments_table']"
    #
    def self.table(element_name, locator)
      define_element(element_name, TestCentricity::Table, locator)
    end

    def self.tables(element_hash)
      element_hash.each do |element_name, locator|
        table(element_name, locator)
      end
    end

    # Declare and instantiate a single select list UI Element for this page section.
    #
    # @param element_name [Symbol] name of select list object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   selectlist :category_selector, 'select#search_form_category_chosen'
    #   selectlist :gender_select,     "//select[@id='customer_gender']"
    #
    def self.selectlist(element_name, locator)
      define_element(element_name, TestCentricity::SelectList, locator)
    end

    def self.selectlists(element_hash)
      element_hash.each do |element_name, locator|
        selectlist(element_name, locator)
      end
    end

    # Declare and instantiate a single list UI Element for this page section.
    #
    # @param element_name [Symbol] name of list object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   list :y_axis_list, 'g.y_axis'
    #
    def self.list(element_name, locator)
      define_element(element_name, TestCentricity::List, locator)
    end

    def self.lists(element_hash)
      element_hash.each do |element_name, locator|
        list(element_name, locator)
      end
    end

    # Declare and instantiate an single image UI Element for this page section.
    #
    # @param element_name [Symbol] name of image object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   image :basket_item_image,    'div.product_image'
    #   image :corporate_logo_image, "//img[@alt='MyCompany_logo']"
    #
    def self.image(element_name, locator)
      define_element(element_name, TestCentricity::Image, locator)
    end

    def self.images(element_hash)
      element_hash.each do |element_name, locator|
        image(element_name, locator)
      end
    end

    # Declare and instantiate a single File Field UI Element for this page section.
    #
    # @param element_name [Symbol] name of file field object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   filefield :attach_file, 's_SweFileName'
    #
    def self.filefield(element_name, locator)
      define_element(element_name, TestCentricity::FileField, locator)
    end

    def self.filefields(element_hash)
      element_hash.each do |element_name, locator|
        filefield(element_name, locator)
      end
    end

    # Declare and instantiate a cell button in a table column on this page section.
    #
    # @param element_name [Symbol] name of cell button object (as a symbol)
    # @param locator [String] XPath expression that uniquely identifies cell button within row and column of parent table object
    # @param table [Symbol] Name (as a symbol) of parent table object
    # @param column [Integer] 1-based index of table column that contains the cell button object
    # @example
    #   cell_button  :show_button, "a[@class='show']", :data_table, 5
    #   cell_button  :edit_button, "a[@class='edit']", :data_table, 5
    #
    def self.cell_button(element_name, locator, table, column)
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::CellButton.new("#{element_name}", self, "#{locator}", :section, #{table}, #{column});end))
    end

    # Declare and instantiate a cell checkbox in a table column on this page section.
    #
    # @param element_name [Symbol] name of cell checkbox object (as a symbol)
    # @param locator [String] XPath expression that uniquely identifies cell checkbox within row and column of parent table object
    # @param table [Symbol] Name (as a symbol) of parent table object
    # @param column [Integer] 1-based index of table column that contains the cell checkbox object
    # @example
    #   cell_checkbox  :is_registered_check, "a[@class='registered']", :data_table, 4
    #
    def self.cell_checkbox(element_name, locator, table, column, proxy = nil)
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::CellCheckBox.new("#{element_name}", self, "#{locator}", :section, #{table}, #{column}, #{proxy});end))
    end

    # Declare and instantiate a cell radio in a table column on this page section.
    #
    # @param element_name [Symbol] name of cell radio object (as a symbol)
    # @param locator [String] XPath expression that uniquely identifies cell radio within row and column of parent table object
    # @param table [Symbol] Name (as a symbol) of parent table object
    # @param column [Integer] 1-based index of table column that contains the cell radio object
    # @example
    #   cell_radio  :track_a_radio, "a[@class='track_a']", :data_table, 8
    #
    def self.cell_radio(element_name, locator, table, column, proxy = nil)
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::CellRadio.new("#{element_name}", self, "#{locator}", :section, #{table}, #{column}, #{proxy});end))
    end

    # Declare and instantiate a cell image in a table column on this page object.
    #
    # @param element_name [Symbol] name of cell image object (as a symbol)
    # @param locator [String] XPath expression that uniquely identifies cell image within row and column of parent table object
    # @param table [Symbol] Name (as a symbol) of parent table object
    # @param column [Integer] 1-based index of table column that contains the cell image object
    # @example
    #   cell_image  :ready_icon, "img[@class='ready']", :data_table, 3
    #   cell_image  :send_icon, "img[@class='send']", :data_table, 3
    #
    def self.cell_image(element_name, locator, table, column)
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::CellImage.new("#{element_name}", self, "#{locator}", :section, #{table}, #{column});end))
    end

    # Declare and instantiate a list button in a row of a list object on this section object.
    #
    # @param element_name [Symbol] name of list button object (as a symbol)
    # @param locator [String] XPath expression that uniquely identifies list button within row of parent list object
    # @param list [Symbol] Name (as a symbol) of parent list object
    # @example
    #   list_button  :delete_button, "a[@class='delete']", :icon_list
    #   list_button  :edit_button, "a[@class='edit']", :icon_list
    #
    def self.list_button(element_name, locator, list)
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::ListButton.new("#{element_name}", self, "#{locator}", :section, #{list});end))
    end

    # Declare and instantiate a list checkbox in a row of a list object on this section object.
    #
    # @param element_name [Symbol] name of list checkbox object (as a symbol)
    # @param locator [String] XPath expression that uniquely identifies list checkbox within row of parent list object
    # @param list [Symbol] Name (as a symbol) of parent list object
    # @example
    #   list_checkbox  :is_registered_check, "a[@class='registered']", :data_list
    #
    def self.list_checkbox(element_name, locator, list, proxy = nil)
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::ListCheckBox.new("#{element_name}", self, "#{locator}", :section, #{list}, #{proxy});end))
    end

    # Declare and instantiate a list radio in a row of a list object on this section object.
    #
    # @param element_name [Symbol] name of list radio object (as a symbol)
    # @param locator [String] XPath expression that uniquely identifies list radio within row of parent list object
    # @param list [Symbol] Name (as a symbol) of parent list object
    # @example
    #   list_radio  :sharing_radio, "a[@class='sharing']", :data_list
    #
    def self.list_radio(element_name, locator, list, proxy = nil)
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::CellRadio.new("#{element_name}", self, "#{locator}", :section, #{list}, #{proxy});end))
    end

    # Instantiate a single PageSection object within this PageSection object.
    #
    # @param section_name [Symbol] name of PageSection object (as a symbol)
    # @param class_name [String] Class name of PageSection object
    # @example
    #   section :search_form, SearchForm
    #
    def self.section(section_name, obj, locator = nil)
      define_method(section_name) do
        ivar_name = "@#{section_name}"
        ivar = instance_variable_get(ivar_name)
        return ivar if ivar
        instance_variable_set(ivar_name, obj.new(section_name, self, "#{locator}", :section))
      end
    end

    def self.sections(section_hash)
      section_hash.each do |section_name, class_name|
        section(section_name, class_name)
      end
    end

    # Does Section object exists?
    #
    # @return [Boolean]
    # @example
    #   navigation_toolbar.exists?
    #
    def exists?
      section, = find_section
      section != nil
    end

    # Is Section object enabled?
    #
    # @return [Boolean]
    # @example
    #   bar_chart_section.enabled?
    #
    def enabled?
      !disabled?
    end

    # Is Section object disabled (not enabled)?
    #
    # @return [Boolean]
    # @example
    #   bar_chart_section.disabled?
    #
    def disabled?
      section, = find_section
      section_not_found_exception(section)
      section.disabled?
    end

    # Is Section object visible?
    #
    # @return [Boolean]
    # @example
    #   navigation_toolbar.visible?
    #
    def visible?
      section, = find_section
      exists = section
      visible = false
      visible = section.visible? if exists
      # the section is visible if it exists and it is not invisible
      exists && visible ? true : false
    end

    # Is Section object hidden (not visible)?
    #
    # @return [Boolean]
    # @example
    #   navigation_toolbar.hidden?
    #
    def hidden?
      !visible?
    end

    # Is section object displayed in browser window?
    #
    # @return [Boolean]
    # @example
    #   navigation_toolbar.displayed??
    #
    def displayed?
      section, = find_section
      section_not_found_exception(section)
      section.displayed?
    end

    # Wait until the Section object exists, or until the specified wait time has expired. If the wait time is nil, then
    # the wait time will be Capybara.default_max_wait_time.
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
      raise "Could not find Section object '#{get_name}' (#{get_locator}) after #{timeout} seconds" unless exists?
    end

    # Wait until the Section object no longer exists, or until the specified wait time has expired. If the wait time is
    # nil, then the wait time will be Capybara.default_max_wait_time.
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
      raise "Section object '#{get_name}' (#{get_locator}) remained visible after #{timeout} seconds" if exists?
    end

    # Wait until the Section object is visible, or until the specified wait time has expired. If the wait time is nil,
    # then the wait time will be Capybara.default_max_wait_time.
    #
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   bar_chart_section.wait_until_visible(0.5)
    #
    def wait_until_visible(seconds = nil)
      timeout = seconds.nil? ? Capybara.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { visible? }
    rescue
      raise "Could not find Section object '#{get_name}' (#{get_locator}) after #{timeout} seconds" unless visible?
    end

    # Wait until the Section object is hidden, or until the specified wait time has expired. If the wait time is nil,
    # then the wait time will be Capybara.default_max_wait_time.
    #
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   bar_chart_section.wait_until_hidden(10)
    #
    def wait_until_hidden(seconds = nil)
      timeout = seconds.nil? ? Capybara.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { hidden? }
    rescue
      raise "Section object '#{get_name}' (#{get_locator}) remained visible after #{timeout} seconds" if visible?
    end

    # Click on a Section object
    #
    # @example
    #   bar_chart_section.click
    #
    def click
      section, = find_section
      section_not_found_exception(section)
      begin
        section.click
      rescue
        section.click_at(10, 10) unless Capybara.current_driver == :poltergeist
      end
    end

    # Double-click on a Section object
    #
    # @example
    #   bar_chart_section.double_click
    #
    def double_click
      section, = find_section
      section_not_found_exception(section)
      page.driver.browser.action.double_click(section.native).perform
    end

    # Right-click on a Section object
    #
    # @example
    #   bar_chart_section.right_click
    #
    def right_click
      section, = find_section
      section_not_found_exception(section)
      page.driver.browser.action.context_click(section.native).perform
    end

    # Click at a specific location within a Section object
    #
    # @param x [Integer] X offset
    # @param y [Integer] Y offset
    # @example
    #   bar_chart_section.click_at(10, 10)
    #
    def click_at(x, y)
      section, = find_section
      section_not_found_exception(section)
      section.click_at(x, y)
    end

    # Send keystrokes to a Section object
    #
    # @param keys [String] keys
    # @example
    #   bar_chart_section.send_keys(:enter)
    #
    def send_keys(*keys)
      section, = find_section
      section_not_found_exception(section)
      section.send_keys(*keys)
    end

    def verify_ui_states(ui_states, fail_message = nil)
      ui_states.each do |ui_object, object_states|
        object_states.each do |property, state|
          case property
          when :class
            actual = ui_object.get_attribute(:class)
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
          when :displayed
            actual = ui_object.displayed?
          when :width
            actual = ui_object.width
          when :height
            actual = ui_object.height
          when :x
            actual = ui_object.x
          when :y
            actual = ui_object.y
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
          when :min
            actual = ui_object.get_min
          when :max
            actual = ui_object.get_max
          when :step
            actual = ui_object.get_step
          when :options, :items, :list_items
            actual = ui_object.get_list_items
          when :optioncount, :itemcount
            actual = ui_object.get_item_count
          when :all_items, :all_list_items
            actual = ui_object.get_all_list_items
          when :all_items_count
            actual = ui_object.get_all_items_count
          when :column_headers
            actual = ui_object.get_header_columns
          when :siebel_options
            actual = ui_object.get_siebel_options
          else
            if property.is_a?(Hash)
              property.each do |key, value|
                case key
                when :cell
                  actual = ui_object.get_table_cell(value[0].to_i, value[1].to_i)
                when :row
                  actual = ui_object.get_table_row(value.to_i)
                when :column
                  actual = ui_object.get_table_column(value.to_i)
                when :item
                  actual = ui_object.get_list_item(value.to_i)
                when :attribute
                  actual = ui_object.get_attribute(value)
                when :native_attribute
                  actual = ui_object.get_native_attribute(value)
                end
              end
            else
              props = property.to_s.split('_')
              case props[0].to_sym
              when :cell
                cell = property.to_s.delete('cell_')
                cell = cell.split('_')
                actual = ui_object.get_table_cell(cell[0].to_i, cell[1].to_i)
              when :row
                row = property.to_s.delete('row_')
                actual = ui_object.get_table_row(row.to_i)
              when :column
                column = property.to_s.delete('column_')
                actual = ui_object.get_table_column(column.to_i)
              when :item
                item = property.to_s.delete('item_')
                actual = ui_object.get_list_item(item.to_i)
              end
            end
          end
          error_msg = "Expected UI object '#{ui_object.get_name}' (#{ui_object.get_locator}) #{property} property to"
          ExceptionQueue.enqueue_comparison(state, actual, error_msg)
        end
      end
    rescue ObjectNotFoundError => e
      ExceptionQueue.enqueue_exception(e.message)
    ensure
      ExceptionQueue.post_exceptions(fail_message)
    end

    # Populate the specified UI elements in this Section object with the associated data from a Hash passed as an
    # argument. Data values must be in the form of a String for textfield and select list controls. For checkbox
    # and radio buttons, data must either be a Boolean or a String that evaluates to a Boolean value (Yes, No, 1,
    # 0, true, false).
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
    # @example
    #   data = { prefix_select      => 'Mr.',
    #            first_name_field   => 'Ignatious',
    #            last_name_field    => 'Snickelfritz',
    #            gender_select      => 'Male',
    #            dob_field          => '12/14/1957',
    #            organ_donor_check  => 'Yes',
    #            dnr_on_file_check  => 'Yes'
    #          }
    #   populate_data_fields(data)
    #
    def populate_data_fields(data, wait_time = nil)
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
            when :section
              data_field.set(data_param)
            end
          end
        end
      end
    end

    def get_attribute(attrib)
      section, = find_section
      section_not_found_exception(section)
      section[attrib]
    end

    def get_native_attribute(attrib)
      section, = find_section
      section_not_found_exception(section)
      section.native.attribute(attrib)
    end

    private

    def find_section
      locator = get_locator
      locator = locator.gsub('|', ' ')
      obj = page.find(@locator_type, locator, wait: 0.1)
      [obj, @locator_type]
    rescue
      [nil, nil]
    end

    def section_not_found_exception(section)
      raise ObjectNotFoundError.new("Section object '#{get_name}' (#{get_locator}) not found") unless section
    end

    def self.define_element(element_name, obj, locator)
      define_method(element_name) do
        ivar_name = "@#{element_name}"
        ivar = instance_variable_get(ivar_name)
        return ivar if ivar
        instance_variable_set(ivar_name, obj.new(element_name, self, locator, :section))
      end
    end
  end
end
