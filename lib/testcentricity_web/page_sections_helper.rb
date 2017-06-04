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


    def initialize(name, parent, locator, context)
      @name         = name
      @parent       = parent
      @locator      = locator
      @context      = context
      @parent_list  = nil
      @list_index   = nil
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
          if locator.include?('/')
            locator = "(#{locator})[#{@list_index}]"
          else
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
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::UIElement.new("#{element_name}", self, "#{locator}", :section);end))
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
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::Button.new("#{element_name}", self, "#{locator}", :section);end))
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
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::TextField.new("#{element_name}", self, "#{locator}", :section);end))
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
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::Label.new("#{element_name}", self, "#{locator}", :section);end))
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
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::Link.new("#{element_name}", self, "#{locator}", :section);end))
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
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::Table.new("#{element_name}", self, "#{locator}", :section);end))
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
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::SelectList.new("#{element_name}", self, "#{locator}", :section);end))
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
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::List.new("#{element_name}", self, "#{locator}", :section);end))
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
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::Image.new("#{element_name}", self, "#{locator}", :section);end))
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
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::FileField.new("#{element_name}", self, "#{locator}", :section);end))
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
    def self.cell_checkbox(element_name, locator, table, column)
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::CellCheckBox.new("#{element_name}", self, "#{locator}", :section, #{table}, #{column});end))
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
    def self.cell_radio(element_name, locator, table, column)
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::CellRadio.new("#{element_name}", self, "#{locator}", :section, #{table}, #{column});end))
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
    def self.list_checkbox(element_name, locator, list)
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::ListCheckBox.new("#{element_name}", self, "#{locator}", :section, #{list});end))
    end

    # Declare and instantiate a list radio in a row of a list object on this section object.
    #
    # @param element_name [Symbol] name of list radio object (as a symbol)
    # @param locator [String] XPath expression that uniquely identifies list radio within row of parent list object
    # @param list [Symbol] Name (as a symbol) of parent list object
    # @example
    #   list_radio  :sharing_radio, "a[@class='sharing']", :data_list
    #
    def self.list_radio(element_name, locator, list)
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::CellRadio.new("#{element_name}", self, "#{locator}", :section, #{list});end))
    end

    # Instantiate a single PageSection object within this PageSection object.
    #
    # @param section_name [Symbol] name of PageSection object (as a symbol)
    # @param class_name [String] Class name of PageSection object
    # @example
    #   section :search_form, SearchForm
    #
    def self.section(section_name, class_name, locator = nil)
      class_eval(%(def #{section_name};@#{section_name} ||= #{class_name}.new("#{section_name}", self, "#{locator}", :section);end))
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
      obj, = find_element
      object_not_found_exception(obj, nil)
      obj.disabled?
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
      raise "Could not find Section object '#{get_name}' (#{get_locator}) after #{timeout} seconds" unless exists?
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
      raise "Section object '#{get_name}' (#{get_locator}) remained visible after #{timeout} seconds" if exists?
    end

    # Wait until the Section object is visible, or until the specified wait time has expired.
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

    # Wait until the Section object is hidden, or until the specified wait time has expired.
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

    # Click at a specific location within a Section object
    #
    # @param x [Integer] X offset
    # @param y [Integer] Y offset
    # @example
    #   bar_chart_section.click_at(10, 10)
    #
    def click_at(x, y)
      section, = find_section
      raise "Section object '#{get_name}' (#{get_locator}) not found" unless section
      section.click_at(x, y)
    end

    def verify_ui_states(ui_states)
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
          when :width
            actual = ui_object.get_width
          when :height
            actual = ui_object.get_height
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

          if state.is_a?(Hash) && state.length == 1
            error_msg = "Expected UI object '#{ui_object.get_name}' (#{ui_object.get_locator}) #{property} property to"
            state.each do |key, value|
              case key
              when :lt, :less_than
                ExceptionQueue.enqueue_exception("#{error_msg} be less than #{value} but found '#{actual}'") unless actual < value
              when :lt_eq, :less_than_or_equal
                ExceptionQueue.enqueue_exception("#{error_msg} be less than or equal to #{value} but found '#{actual}'") unless actual <= value
              when :gt, :greater_than
                ExceptionQueue.enqueue_exception("#{error_msg} be greater than #{value} but found '#{actual}'") unless actual > value
              when :gt_eq, :greater_than_or_equal
                ExceptionQueue.enqueue_exception("#{error_msg} be greater than or equal to  #{value} but found '#{actual}'") unless actual >= value
              when :starts_with
                ExceptionQueue.enqueue_exception("#{error_msg} start with '#{value}' but found '#{actual}'") unless actual.start_with?(value)
              when :ends_with
                ExceptionQueue.enqueue_exception("#{error_msg} end with '#{value}' but found '#{actual}'") unless actual.end_with?(value)
              when :contains
                ExceptionQueue.enqueue_exception("#{error_msg} contain '#{value}' but found '#{actual}'") unless actual.include?(value)
              when :not_contains, :does_not_contain
                ExceptionQueue.enqueue_exception("#{error_msg} not contain '#{value}' but found '#{actual}'") if actual.include?(value)
              when :not_equal
                ExceptionQueue.enqueue_exception("#{error_msg} not equal '#{value}' but found '#{actual}'") if actual == value
              when :like, :is_like
                actual_like = actual.delete("\n")
                actual_like = actual_like.delete("\r")
                actual_like = actual_like.delete("\t")
                actual_like = actual_like.delete(' ')
                actual_like = actual_like.downcase
                expected    = value.delete("\n")
                expected    = expected.delete("\r")
                expected    = expected.delete("\t")
                expected    = expected.delete(' ')
                expected    = expected.downcase
                ExceptionQueue.enqueue_exception("#{error_msg} be like '#{value}' but found '#{actual}'") unless actual_like.include?(expected)
              when :translate
                expected = I18n.t(value)
                ExceptionQueue.enqueue_assert_equal(expected, actual, "Expected UI object '#{ui_object.get_name}' (#{ui_object.get_locator}) translated #{property} property")
              end
            end
          else
            ExceptionQueue.enqueue_assert_equal(state, actual, "Expected UI object '#{ui_object.get_name}' (#{ui_object.get_locator}) #{property} property")
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
    #   populate_data_fields(data)
    #
    def populate_data_fields(data)
      data.each do |data_field, data_param|
        unless data_param.blank?
          # make sure the intended UI target element exists before trying to set its value
          data_field.wait_until_exists(2)
          if data_param == '!DELETE'
            data_field.set('')
          else
            case data_field.get_object_type
            when :checkbox
              data_field.set_checkbox_state(data_param.to_bool)
            when :selectlist
              data_field.get_siebel_object_type == 'JComboBox' ?
                  data_field.set("#{data_param}\t") :
                  data_field.choose_option(data_param)
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
      raise "Section object '#{get_name}' (#{get_locator}) not found" unless section
      section[attrib]
    end

    def get_native_attribute(attrib)
      section, = find_section
      raise "Section object '#{get_name}' (#{get_locator}) not found" unless section
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
        locator = locator.delete('|')
      when :xpath
        locator = locator.delete('|')
      end
      obj = page.find(type, locator, :wait => 0.1)
      [obj, type]
    rescue
      retry if (tries -= 1) > 0
      [nil, nil]
    end
  end
end
