module TestCentricity
  class PageObject < BasePageSectionObject
    def initialize
      set_locator_type(page_locator) if defined?(page_locator)
    end

    # Declare and instantiate a single generic UI Element for this page object.
    #
    # @param element_name [Symbol] name of UI object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   element :settings_item, 'a#userPreferencesTrigger'
    #
    def self.element(element_name, locator)
      define_page_element(element_name, TestCentricity::Elements::UIElement, locator)
    end

    # Declare and instantiate a collection of generic UI Elements for this page object.
    #
    # @param element_hash [Hash] names of UI objects (as a symbol) and CSS selectors or XPath expressions that uniquely identifies objects
    # @example
    #   elements profile_item:  'a#profile',
    #            settings_item: 'a#userPreferencesTrigger',
    #            log_out_item:  'a#logout'
    #
    def self.elements(element_hash)
      element_hash.each_pair { |element_name, locator| element(element_name, locator) }
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
      define_page_element(element_name, TestCentricity::Elements::Button, locator)
    end

    # Declare and instantiate a collection of buttons for this page object.
    #
    # @param element_hash [Hash] names of buttons (as a symbol) and CSS selectors or XPath expressions that uniquely identifies buttons
    # @example
    #     buttons new_account_button: 'button#new-account',
    #             save_button:        'button#save',
    #             cancel_button:      'button#cancel'
    #
    def self.buttons(element_hash)
      element_hash.each_pair { |element_name, locator| button(element_name, locator) }
    end

    # Declare and instantiate a single text field UI Element for this page object.
    #
    # @param element_name [Symbol] name of text field object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   textfield :user_id_field,  "//input[@id='UserName']"
    #   textfield :password_field, 'input#consumer_password'
    #
    def self.textfield(element_name, locator)
      define_page_element(element_name, TestCentricity::Elements::TextField, locator)
    end

    # Declare and instantiate a collection of text fields for this page object.
    #
    # @param element_hash [Hash] names of text fields (as a symbol) and CSS selectors or XPath expressions that uniquely identifies text fields
    # @example
    #       textfields name_field:  'input#Name',
    #                  title_field: 'input#Title',
    #                  phone_field: 'input#PhoneNumber',
    #                  email_field: 'input#Email'
    #
    def self.textfields(element_hash)
      element_hash.each_pair { |element_name, locator| textfield(element_name, locator) }
    end

    # Declare and instantiate a single range input UI Element for this page object.
    #
    # @param element_name [Symbol] name of range input object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   range :volume_level, "//input[@id='volume_slider']"
    #   range :points_slider, 'input#points'
    #
    def self.range(element_name, locator)
      define_page_element(element_name, TestCentricity::Elements::Range, locator)
    end

    # Declare and instantiate a collection of range inputs for this page object.
    #
    # @param element_hash [Hash] names of ranges (as a symbol) and CSS selectors or XPath expressions that uniquely identifies the ranges
    # @example
    #       ranges points_slider: 'input#points',
    #              risk_slider:   'input#risk_percentage'
    #
    def self.ranges(element_hash)
      element_hash.each_pair { |element_name, locator| range(element_name, locator) }
    end

    # Declare and instantiate a single checkbox UI Element for this page object.
    #
    # @param element_name [Symbol] name of checkbox object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   checkbox :remember_checkbox,     "//input[@id='RememberUser']"
    #   checkbox :accept_terms_checkbox, 'input#accept_terms_conditions'
    #
    def self.checkbox(element_name, locator)
      define_page_element(element_name, TestCentricity::Elements::CheckBox, locator)
    end

    # Declare and instantiate a collection of checkboxes for this page object.
    #
    # @param element_hash [Hash] names of checkboxes (as a symbol) and CSS selectors or XPath expressions that uniquely identifies checkboxes
    # @example
    #       checkboxes hazmat_certified_check: 'input#hazmatCertified',
    #                  epa_certified_check:    'input#epaCertified',
    #                  dhs_certified_check:    'input#homelandSecurityCertified',
    #                  carb_compliant_check:   'input#carbCompliant'
    #
    def self.checkboxes(element_hash)
      element_hash.each_pair { |element_name, locator| checkbox(element_name, locator) }
    end

    # Declare and instantiate a single radio button UI Element for this page object.
    #
    # @param element_name [Symbol] name of radio object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   radio :accept_terms_radio,  "//input[@id='Accept_Terms']"
    #   radio :decline_terms_radio, '#decline_terms_conditions'
    #
    def self.radio(element_name, locator)
      define_page_element(element_name, TestCentricity::Elements::Radio, locator)
    end

    # Declare and instantiate a collection of radio buttons for this page object.
    #
    # @param element_hash [Hash] names of radio buttons (as a symbol) and CSS selectors or XPath expressions that uniquely identifies radio buttons
    # @example
    #       radios visa_radio:       'input#payWithVisa',
    #              mastercard_radio: 'input#payWithMastercard',
    #              discover_radio:   'input#payWithDiscover',
    #              amex_radio:       'input#payWithAmEx'
    #
    def self.radios(element_hash)
      element_hash.each_pair { |element_name, locator| radio(element_name, locator) }
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
      define_page_element(element_name, TestCentricity::Elements::Label, locator)
    end

    # Declare and instantiate a collection of labels for this page object.
    #
    # @param element_hash [Hash] names of labels (as a symbol) and CSS selectors or XPath expressions that uniquely identifies labels
    # @example
    #       labels username_label: 'label#username',
    #              password_label: 'label#password'
    #
    def self.labels(element_hash)
      element_hash.each_pair { |element_name, locator| label(element_name, locator) }
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
      define_page_element(element_name, TestCentricity::Elements::Link, locator)
    end

    def self.links(element_hash)
      element_hash.each_pair { |element_name, locator| link(element_name, locator) }
    end

    # Declare and instantiate a single table UI Element for this page object.
    #
    # @param element_name [Symbol] name of table object (as a symbol)
    # @param locator [String] XPath expression that uniquely identifies object
    # @example
    #   table :payments_table, "//table[@class='payments_table']"
    #
    def self.table(element_name, locator)
      define_page_element(element_name, TestCentricity::Elements::Table, locator)
    end

    def self.tables(element_hash)
      element_hash.each_pair { |element_name, locator| table(element_name, locator) }
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
      define_page_element(element_name, TestCentricity::Elements::SelectList, locator)
    end

    def self.selectlists(element_hash)
      element_hash.each_pair { |element_name, locator| selectlist(element_name, locator) }
    end

    # Declare and instantiate a single list UI Element for this page object.
    #
    # @param element_name [Symbol] name of list object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   list :x_axis_list, 'g.x-axis'
    #
    def self.list(element_name, locator)
      define_page_element(element_name, TestCentricity::Elements::List, locator)
    end

    def self.lists(element_hash)
      element_hash.each_pair { |element_name, locator| list(element_name, locator) }
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
      define_page_element(element_name, TestCentricity::Elements::Image, locator)
    end

    def self.images(element_hash)
      element_hash.each_pair { |element_name, locator| image(element_name, locator) }
    end

    # Declare and instantiate a single HTML5 video UI Element for this page object.
    #
    # @param element_name [Symbol] name of an HTML5 video object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   video :video_player, 'video#my_video_player'
    #
    def self.video(element_name, locator)
      define_page_element(element_name, TestCentricity::Elements::Video, locator)
    end

    def self.videos(element_hash)
      element_hash.each_pair { |element_name, locator| video(element_name, locator) }
    end

    # Declare and instantiate a single HTML5 audio UI Element for this page object.
    #
    # @param element_name [Symbol] name of an HTML5 audio object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   audio :audio_player, 'audio#my_audio_player'
    #
    def self.audio(element_name, locator)
      define_page_element(element_name, TestCentricity::Elements::Audio, locator)
    end

    def self.audios(element_hash)
      element_hash.each_pair { |element_name, locator| audio(element_name, locator) }
    end

    # Declare and instantiate a single File Field UI Element for this page object.
    #
    # @param element_name [Symbol] name of file field object (as a symbol)
    # @param locator [String] CSS selector or XPath expression that uniquely identifies object
    # @example
    #   filefield :attach_file, 's_SweFileName'
    #
    def self.filefield(element_name, locator)
      define_page_element(element_name, TestCentricity::Elements::FileField, locator)
    end

    def self.filefields(element_hash)
      element_hash.each_pair { |element_name, locator| filefield(element_name, locator) }
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
      section_hash.each_pair { |section_name, class_name| section(section_name, class_name) }
    end

    def open_portal
      visit Environ.current.app_host
      Environ.portal_state = :open
    end

    def verify_page_exists
      raise "Page object #{self.class.name} does not have a page_locator trait defined" unless defined?(page_locator)

      set_locator_type(page_locator) if @locator_type.blank?
      unless page.has_selector?(@locator_type, page_locator)
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

    # Return page title
    #
    # @return [String]
    # @example
    #   home_page.title
    #
    def title
      page.driver.browser.title
    end

    # Send keystrokes to the focused element on a Page object
    #
    # @param keys [String] keys
    # @example
    #   editor_page.send_keys([:control, 'z'])
    #
    def send_keys(*keys)
      focused_obj = page.driver.browser.switch_to.active_element
      focused_obj.send_keys(*keys)
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
          break if active.zero?
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
