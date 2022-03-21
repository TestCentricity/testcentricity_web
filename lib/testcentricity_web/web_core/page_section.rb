module TestCentricity
  class PageSection < BasePageSectionObject
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
      set_locator_type
    end

    def get_locator
      locator = if @locator.empty? && defined?(section_locator)
                  section_locator
                else
                  @locator
                end
      unless @parent_list.nil?
        locator = if @locator_type == @parent_list.get_locator_type
                    "#{@parent_list.get_locator} #{locator}"
                  else
                    "#{@parent_list.get_locator}|#{locator}"
                  end
        unless @list_index.nil?
          locator = if @locator_type == :xpath
                      "#{locator}[#{@list_index}]"
                    else
                      "#{locator}:nth-of-type(#{@list_index})"
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

    def get_parent_list
      @parent_list
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

    # Declare and instantiate a single generic UI Element for this page section.
    #
    # @param element_name [Symbol] name of UI object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   element :undo_record_item, "//li[@rn='Undo Record']/a"
    #   element :basket_header,    'div.basket_header'
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
      element_hash.each(&method(:element))
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
    #     buttons new_account_button: 'button#new-account',
    #             save_button:        'button#save',
    #             cancel_button:      'button#cancel'
    #
    def self.buttons(element_hash)
      element_hash.each(&method(:button))
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
    #       textfields  name_field:  'input#Name',
    #                   title_field: 'input#Title',
    #                   phone_field: 'input#PhoneNumber',
    #                   fax_field:   'input#FaxNumber',
    #                   email_field: 'input#Email'
    #
    def self.textfields(element_hash)
      element_hash.each(&method(:textfield))
    end

    # Declare and instantiate a single range input UI Element for this page section.
    #
    # @param element_name [Symbol] name of range input object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   range :volume_level, "//input[@id='volume_slider']"
    #   range :points_slider, 'input#points'
    #
    def self.range(element_name, locator)
      define_element(element_name, TestCentricity::Range, locator)
    end

    # Declare and instantiate a collection of range inputs for this page section.
    #
    # @param element_hash [Hash] names of ranges (as a symbol) and CSS selectors or XPath expressions that uniquely identifies the ranges
    # @example
    #       ranges points_slider: 'input#points',
    #              risk_slider:   'input#risk_percentage'
    #
    def self.ranges(element_hash)
      element_hash.each(&method(:range))
    end

    # Declare and instantiate a single checkbox UI Element for this page section.
    #
    # @param element_name [Symbol] name of checkbox object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   checkbox :remember_checkbox,     "//input[@id='RememberUser']"
    #   checkbox :accept_terms_checkbox, 'input#accept_terms_conditions'
    #
    def self.checkbox(element_name, locator)
      define_element(element_name, TestCentricity::CheckBox, locator)
    end

    # Declare and instantiate a collection of checkboxes for this page section.
    #
    # @param element_hash [Hash] names of checkboxes (as a symbol) and CSS selectors or XPath expressions that uniquely identifies checkboxes
    # @example
    #       checkboxes  hazmat_certified_check: 'input#hazmatCertified',
    #                   epa_certified_check:    'input#epaCertified',
    #                   dhs_certified_check:    'input#homelandSecurityCertified',
    #                   carb_compliant_check:   'input#carbCompliant'
    #
    def self.checkboxes(element_hash)
      element_hash.each(&method(:checkbox))
    end

    # Declare and instantiate a single radio button UI Element for this page section.
    #
    # @param element_name [Symbol] name of radio object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   radio :accept_terms_radio,  "//input[@id='Accept_Terms']"
    #   radio :decline_terms_radio, 'input#decline_terms_conditions'
    #
    def self.radio(element_name, locator, proxy = nil)
      define_element(element_name, TestCentricity::Radio, locator)
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
      element_hash.each(&method(:radio))
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
      element_hash.each(&method(:label))
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
      element_hash.each(&method(:link))
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
      element_hash.each(&method(:table))
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
      element_hash.each(&method(:selectlist))
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
      element_hash.each(&method(:list))
    end

    # Declare and instantiate a single image UI Element for this page section.
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
      element_hash.each(&method(:image))
    end

    # Declare and instantiate a single video UI Element for this page section.
    #
    # @param element_name [Symbol] name of video object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   video :video_player, 'video#my_video_player'
    #
    def self.video(element_name, locator)
      define_element(element_name, TestCentricity::Video, locator)
    end

    def self.videos(element_hash)
      element_hash.each(&method(:video))
    end

    # Declare and instantiate a single HTML5 audio UI Element for this page section.
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
      element_hash.each(&method(:audio))
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
      element_hash.each(&method(:filefield))
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
    def wait_until_exists(seconds = nil, post_exception = true)
      timeout = seconds.nil? ? Capybara.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { exists? }
    rescue
      if post_exception
        raise "Could not find Section object '#{get_name}' (#{get_locator}) after #{timeout} seconds" unless exists?
      else
        exists?
      end
    end

    # Wait until the Section object no longer exists, or until the specified wait time has expired. If the wait time is
    # nil, then the wait time will be Capybara.default_max_wait_time.
    #
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   navigation_toolbar.wait_until_gone(5)
    #
    def wait_until_gone(seconds = nil, post_exception = true)
      timeout = seconds.nil? ? Capybara.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { !exists? }
    rescue
      if post_exception
        raise "Section object '#{get_name}' (#{get_locator}) remained visible after #{timeout} seconds" if exists?
      else
        exists?
      end
    end

    # Wait until the Section object is visible, or until the specified wait time has expired. If the wait time is nil,
    # then the wait time will be Capybara.default_max_wait_time.
    #
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   bar_chart_section.wait_until_visible(0.5)
    #
    def wait_until_visible(seconds = nil, post_exception = true)
      timeout = seconds.nil? ? Capybara.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { visible? }
    rescue
      if post_exception
        raise "Could not find Section object '#{get_name}' (#{get_locator}) after #{timeout} seconds" unless visible?
      else
        visible?
      end
    end

    # Wait until the Section object is hidden, or until the specified wait time has expired. If the wait time is nil,
    # then the wait time will be Capybara.default_max_wait_time.
    #
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   bar_chart_section.wait_until_hidden(10)
    #
    def wait_until_hidden(seconds = nil, post_exception = true)
      timeout = seconds.nil? ? Capybara.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { hidden? }
    rescue
      if post_exception
        raise "Section object '#{get_name}' (#{get_locator}) remained visible after #{timeout} seconds" if visible?
      else
        visible?
      end
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

    # Hover the cursor over a Section object
    #
    # @example
    #   bar_chart_section.hover
    #
    def hover
      section, = find_section
      section_not_found_exception(section)
      section.hover
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
      locator = locator.tr('|', ' ')
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
