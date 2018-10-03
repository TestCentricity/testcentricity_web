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

    # Declare and instantiate a single generic UI Element for this page object.
    #
    # @param element_name [Symbol] name of UI object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   element :siebel_view,  'div#_sweview'
    #   element :siebel_busy,  "//html[contains(@class, 'siebui-busy')]"
    #
    def self.element(element_name, locator)
      define_page_element(element_name, TestCentricity::UIElement, locator)
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

    # Declare and instantiate a single button UI Element for this page object.
    #
    # @param element_name [Symbol] name of button object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   button :checkout_button, 'button.checkout_button'
    #   button :login_button,    "//input[@id='submit_button']"
    #
    def self.button(element_name, locator)
      define_page_element(element_name, TestCentricity::Button, locator)
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

    # Declare and instantiate a single text field UI Element for this page object.
    #
    # @param element_name [Symbol] name of text field object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   textfield :user_id_field,  "//input[@id='UserName']"
    #   textfield :password_field, 'consumer_password'
    #
    def self.textfield(element_name, locator)
      define_page_element(element_name, TestCentricity::TextField, locator)
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

    # Declare and instantiate a single checkbox UI Element for this page object.
    #
    # @param element_name [Symbol] name of checkbox object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @param proxy [Symbol] Optional name (as a symbol) of proxy object to receive click actions
    # @example
    #   checkbox :remember_checkbox,     "//input[@id='RememberUser']"
    #   checkbox :accept_terms_checkbox, 'input#accept_terms_conditions', :accept_terms_label
    #
    def self.checkbox(element_name, locator, proxy = nil)
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::CheckBox.new("#{element_name}", self, "#{locator}", :page, #{proxy});end))
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

    # Declare and instantiate a single radio button UI Element for this page object.
    #
    # @param element_name [Symbol] name of radio object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @param proxy [Symbol] Optional name (as a symbol) of proxy object to receive click actions
    # @example
    #   radio :accept_terms_radio,  "//input[@id='Accept_Terms']"
    #   radio :decline_terms_radio, '#decline_terms_conditions', :decline_terms_label
    #
    def self.radio(element_name, locator, proxy = nil)
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::Radio.new("#{element_name}", self, "#{locator}", :page, #{proxy});end))
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

    # Declare and instantiate a single label UI Element for this page object.
    #
    # @param element_name [Symbol] name of label object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   label :welcome_label,      'div.Welcome'
    #   label :rollup_price_label, "//div[contains(@id, 'Rollup Item Price')]"
    #
    def self.label(element_name, locator)
      define_page_element(element_name, TestCentricity::Label, locator)
    end

    def self.labels(element_hash)
      element_hash.each do |element_name, locator|
        label(element_name, locator)
      end
    end

    # Declare and instantiate a single link UI Element for this page object.
    #
    # @param element_name [Symbol] name of link object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   link :registration_link,    'a.account-nav__link.register'
    #   link :shopping_basket_link, "//a[@href='shopping_basket']"
    #
    def self.link(element_name, locator)
      define_page_element(element_name, TestCentricity::Link, locator)
    end

    def self.links(element_hash)
      element_hash.each do |element_name, locator|
        link(element_name, locator)
      end
    end

    # Declare and instantiate a single table UI Element for this page object.
    #
    # @param element_name [Symbol] name of table object (as a symbol)
    # @param locator [String] XPath expression that uniquely identifies object
    # @example
    #   table :payments_table, "//table[@class='payments_table']"
    #
    def self.table(element_name, locator)
      define_page_element(element_name, TestCentricity::Table, locator)
    end

    def self.tables(element_hash)
      element_hash.each do |element_name, locator|
        table(element_name, locator)
      end
    end

    # Declare and instantiate a single select list UI Element for this page object.
    #
    # @param element_name [Symbol] name of select list object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   selectlist :category_selector, 'select#search_form_category_chosen'
    #   selectlist :gender_select,     "//select[@id='customer_gender']"
    #
    def self.selectlist(element_name, locator)
      define_page_element(element_name, TestCentricity::SelectList, locator)
    end

    def self.selectlists(element_hash)
      element_hash.each do |element_name, locator|
        selectlist(element_name, locator)
      end
    end

    # Declare and instantiate a single list UI Element for this page object.
    #
    # @param element_name [Symbol] name of list object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   list :x_axis_list, 'g.x-axis'
    #
    def self.list(element_name, locator)
      define_page_element(element_name, TestCentricity::List, locator)
    end

    def self.lists(element_hash)
      element_hash.each do |element_name, locator|
        list(element_name, locator)
      end
    end

    # Declare and instantiate an single image UI Element for this page object.
    #
    # @param element_name [Symbol] name of image object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   image :basket_item_image,    'div.product_image'
    #   image :corporate_logo_image, "//img[@alt='MyCompany_logo']"
    #
    def self.image(element_name, locator)
      define_page_element(element_name, TestCentricity::Image, locator)
    end

    def self.images(element_hash)
      element_hash.each do |element_name, locator|
        image(element_name, locator)
      end
    end

    # Declare and instantiate a single HTML5 video UI Element for this page object.
    #
    # @param element_name [Symbol] name of an HTML5 video object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   video :video_player, 'video#my_video_player'
    #
    def self.video(element_name, locator)
      define_element(element_name, TestCentricity::Video, locator)
    end

    def self.videos(element_hash)
      element_hash.each do |element_name, locator|
        video(element_name, locator)
      end
    end

    # Declare and instantiate a single HTML5 audio UI Element for this page object.
    #
    # @param element_name [Symbol] name of an HTML5 audio object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   audio :audio_player, 'audio#my_audio_player'
    #
    def self.audio(element_name, locator)
      define_element(element_name, TestCentricity::Audio, locator)
    end

    def self.audios(element_hash)
      element_hash.each do |element_name, locator|
        audio(element_name, locator)
      end
    end

    # Declare and instantiate a single File Field UI Element for this page object.
    #
    # @param element_name [Symbol] name of file field object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   filefield :attach_file, 's_SweFileName'
    #
    def self.filefield(element_name, locator)
      define_page_element(element_name, TestCentricity::FileField, locator)
    end

    def self.filefields(element_hash)
      element_hash.each do |element_name, locator|
        filefield(element_name, locator)
      end
    end

    # Declare and instantiate a cell button in a table column on this page object.
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
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::CellButton.new("#{element_name}", self, "#{locator}", :page, #{table}, #{column});end))
    end

    # Declare and instantiate a cell checkbox in a table column on this page object.
    #
    # @param element_name [Symbol] name of cell checkbox object (as a symbol)
    # @param locator [String] XPath expression that uniquely identifies cell checkbox within row and column of parent table object
    # @param table [Symbol] Name (as a symbol) of parent table object
    # @param column [Integer] 1-based index of table column that contains the cell checkbox object
    # @example
    #   cell_checkbox  :is_registered_check, "a[@class='registered']", :data_table, 4
    #
    def self.cell_checkbox(element_name, locator, table, column, proxy = nil)
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::CellCheckBox.new("#{element_name}", self, "#{locator}", :page, #{table}, #{column}, #{proxy});end))
    end

    # Declare and instantiate a cell radio in a table column on this page object.
    #
    # @param element_name [Symbol] name of cell radio object (as a symbol)
    # @param locator [String] XPath expression that uniquely identifies cell radio within row and column of parent table object
    # @param table [Symbol] Name (as a symbol) of parent table object
    # @param column [Integer] 1-based index of table column that contains the cell radio object
    # @example
    #   cell_radio  :track_a_radio, "a[@class='track_a']", :data_table, 8
    #
    def self.cell_radio(element_name, locator, table, column, proxy = nil)
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::CellRadio.new("#{element_name}", self, "#{locator}", :page, #{table}, #{column}, #{proxy});end))
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
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::CellImage.new("#{element_name}", self, "#{locator}", :page, #{table}, #{column});end))
    end

    # Declare and instantiate a list button in a row of a list object on this page object.
    #
    # @param element_name [Symbol] name of list button object (as a symbol)
    # @param locator [String] XPath expression that uniquely identifies list button within row of parent list object
    # @param list [Symbol] Name (as a symbol) of parent list object
    # @example
    #   list_button  :delete_button, "a[@class='delete']", :icon_list
    #   list_button  :edit_button, "a[@class='edit']", :icon_list
    #
    def self.list_button(element_name, locator, list)
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::ListButton.new("#{element_name}", self, "#{locator}", :page, #{list});end))
    end

    # Declare and instantiate a list checkbox in a row of a list object on this page object.
    #
    # @param element_name [Symbol] name of list checkbox object (as a symbol)
    # @param locator [String] XPath expression that uniquely identifies list checkbox within row of parent list object
    # @param list [Symbol] Name (as a symbol) of parent list object
    # @example
    #   list_checkbox  :is_registered_check, "a[@class='registered']", :data_list
    #
    def self.list_checkbox(element_name, locator, list, proxy = nil)
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::ListCheckBox.new("#{element_name}", self, "#{locator}", :page, #{list}, #{proxy});end))
    end

    # Declare and instantiate a list radio in a row of a list object on this page object.
    #
    # @param element_name [Symbol] name of list radio object (as a symbol)
    # @param locator [String] XPath expression that uniquely identifies list radio within row of parent list object
    # @param list [Symbol] Name (as a symbol) of parent list object
    # @example
    #   list_radio  :sharing_radio, "a[@class='sharing']", :data_list
    #
    def self.list_radio(element_name, locator, list, proxy = nil)
      class_eval(%(def #{element_name};@#{element_name} ||= TestCentricity::ListRadio.new("#{element_name}", self, "#{locator}", :page, #{list}, #{proxy});end))
    end

    # Instantiate a single PageSection object for this page object.
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
        instance_variable_set(ivar_name, obj.new(section_name, self, "#{locator}", :page))
      end
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
      Environ.portal_state = :open
    end

    def verify_page_exists
      raise "Page object #{self.class.name} does not have a page_locator trait defined" unless defined?(page_locator)
      unless page.has_selector?(page_locator)
        body_class = find(:xpath, '//body')[:class]
        error_message = %(
          Expected page to have selector '#{page_locator}' but found '#{body_class}' instead.
          Actual URL of page loaded = #{URI.parse(current_url)}.
          )
        error_message = "#{error_message}\nExpected URL of page was #{page_url}." if defined?(page_url)
        raise error_message
      end
      PageManager.current_page = self
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

    # Wait until the page object exists, or until the specified wait time has expired. If the wait time is nil, then the wait
    # time will be Capybara.default_max_wait_time.
    #
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   home_page.wait_until_exists(15)
    #
    def wait_until_exists(seconds = nil, post_exception = true)
      timeout = seconds.nil? ? Capybara.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { exists? }
    rescue
      if post_exception
        raise "Page object #{self.class.name} not found after #{timeout} seconds" unless exists?
      else
        exists?
      end
    end

    # Wait until the page object no longer exists, or until the specified wait time has expired. If the wait time is nil, then
    # the wait time will be Capybara.default_max_wait_time.
    #
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   payment_processing_page.wait_until_gone(15)
    #
    def wait_until_gone(seconds = nil, post_exception = true)
      timeout = seconds.nil? ? Capybara.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { !exists? }
    rescue
      if post_exception
        raise "Page object #{self.class.name} remained visible after #{timeout} seconds" if exists?
      else
        exists?
      end
    end

    # Wait until all AJAX requests have completed, or until the specified wait time has expired. If the wait time is nil, then
    # the wait time will be Capybara.default_max_wait_time.
    #
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   shopping_basket_page.wait_for_ajax(15)
    #
    def wait_for_ajax(seconds = nil)
      wait_time = seconds.nil? ? Capybara.default_max_wait_time : seconds
      Timeout.timeout(wait_time) do
        loop do
          active = page.evaluate_script('jQuery.active')
          break if active == 0
        end
      end
    end

    # Is current Page object URL secure?
    #
    # @return [Boolean]
    # @example
    #   home_page.secure?
    #
    def secure?
      current_url.start_with?('https')
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
          when :loaded
            actual = ui_object.loaded?
          when :broken
            actual = ui_object.broken?
          when :alt
            actual = ui_object.alt
          when :src
            actual = ui_object.src
          when :autoplay
            actual = ui_object.autoplay?
          when :ended
            actual = ui_object.ended?
          when :controls
            actual = ui_object.controls?
          when :loop
            actual = ui_object.loop?
          when :muted
            actual = ui_object.muted?
          when :default_muted
            actual = ui_object.default_muted?
          when :paused
            actual = ui_object.paused?
          when :seeking
            actual = ui_object.seeking?
          when :current_time
            actual = ui_object.current_time
          when :default_playback_rate
            actual = ui_object.default_playback_rate
          when :duration
            actual = ui_object.duration
          when :playback_rate
            actual = ui_object.playback_rate
          when :ready_state
            actual = ui_object.ready_state
          when :volume
            actual = ui_object.volume
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
          when :count, :count_visible
            actual = ui_object.count(visible = true)
          when :count_all
            actual = ui_object.count(visible = :all)
          when :siebel_options
            actual = ui_object.get_siebel_options
          when :style
            actual = ui_object.style
          when :aria_label
            actual = ui_object.aria_label
          when :aria_disabled
            actual = ui_object.aria_disabled?
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
          ExceptionQueue.enqueue_comparison(ui_object, state, actual, error_msg)
        end
      end
    rescue ObjectNotFoundError => e
      ExceptionQueue.enqueue_exception(e.message)
    ensure
      ExceptionQueue.post_exceptions(fail_message)
    end

    # Populate the specified UI elements on this page with the associated data from a Hash passed as an argument. Data
    # values must be in the form of a String for textfield and select list controls. For checkbox and radio buttons,
    # data must either be a Boolean or a String that evaluates to a Boolean value (Yes, No, 1, 0, true, false).
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

    private

    def self.define_page_element(element_name, obj, locator)
      define_method(element_name) do
        ivar_name = "@#{element_name}"
        ivar = instance_variable_get(ivar_name)
        return ivar if ivar
        instance_variable_set(ivar_name, obj.new(element_name, self, locator, :page))
      end
    end
  end
end
