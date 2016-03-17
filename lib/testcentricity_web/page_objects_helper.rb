require 'test/unit'

module TestCentricity
  class PageObject
    include Capybara::DSL
    include Capybara::Node::Matchers
    include RSpec::Matchers
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
    # @param locator [String] css selector or xpath expression that uniquely identifies object
    # @example
    #   element :siebel_view,  'div#_sweview'
    #   element :siebel_busy,  "//html[contains(@class, 'siebui-busy')]"
    #
    def self.element(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::UIElement.new(self, "#{locator}", :page, nil);end))
    end

    # Declare and instantiate a button UI Element for this page object.
    #
    # @param element_name [Symbol] name of button object (as a symbol)
    # @param locator [String] css selector or xpath expression that uniquely identifies object
    # @example
    #   button :checkout_button, "button.checkout_button"
    #   button :login_button,    "//input[@id='submit_button']"
    #
    def self.button(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::UIElement.new(self, "#{locator}", :page, :button);end))
    end

    # Declare and instantiate a text field UI Element for this page object.
    #
    # @param element_name [Symbol] name of text field object (as a symbol)
    # @param locator [String] css selector or xpath expression that uniquely identifies object
    # @example
    #   textfield :user_id_field,  "//input[@id='UserName']"
    #   textfield :password_field, "consumer_password"
    #
    def self.textfield(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::UIElement.new(self, "#{locator}", :page, :textfield);end))
    end

    # Declare and instantiate a checkbox UI Element for this page object.
    #
    # @param element_name [Symbol] name of checkbox object (as a symbol)
    # @param locator [String] css selector or xpath expression that uniquely identifies object
    # @example
    #   checkbox :remember_checkbox,     "//input[@id='RememberUser']"
    #   checkbox :accept_terms_checkbox, "accept_terms_conditions"
    #
    def self.checkbox(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::UIElement.new(self, "#{locator}", :page, :checkbox);end))
    end

    # Declare and instantiate a label UI Element for this page object.
    #
    # @param element_name [Symbol] name of label object (as a symbol)
    # @param locator [String] css selector or xpath expression that uniquely identifies object
    # @example
    #   label :welcome_label,      'div.Welcome'
    #   label :rollup_price_label, "//div[contains(@id, 'Rollup Item Price')]"
    #
    def self.label(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::UIElement.new(self, "#{locator}", :page, :label);end))
    end

    # Declare and instantiate a link UI Element for this page object.
    #
    # @param element_name [Symbol] name of link object (as a symbol)
    # @param locator [String] css selector or xpath expression that uniquely identifies object
    # @example
    #   link :registration_link,    "a.account-nav__link.register"
    #   link :shopping_basket_link, "//a[@href='shopping_basket']"
    #
    def self.link(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::UIElement.new(self, "#{locator}", :page, :link);end))
    end

    # Declare and instantiate a table UI Element for this page object.
    #
    # @param element_name [Symbol] name of table object (as a symbol)
    # @param locator [String] css selector or xpath expression that uniquely identifies object
    # @example
    #   table :payments_table, "//table[@class='payments_table']"
    #
    def self.table(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::UIElement.new(self, "#{locator}", :page, :table);end))
    end

    # Declare and instantiate a select list UI Element for this page object.
    #
    # @param element_name [Symbol] name of select list object (as a symbol)
    # @param locator [String] css selector or xpath expression that uniquely identifies object
    # @example
    #   selectlist :category_selector, "search_form_category_chosen"
    #   selectlist :gender_select,     "//select[@id='customer_gender']"
    #
    def self.selectlist(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::UIElement.new(self, "#{locator}", :page, :selectlist);end))
    end

    # Declare and instantiate an image UI Element for this page object.
    #
    # @param element_name [Symbol] name of image object (as a symbol)
    # @param locator [String] css selector or xpath expression that uniquely identifies object
    # @example
    #   image :basket_item_image,    "div.product_image"
    #   image :corporate_logo_image, "//img[@alt='MyCompany_logo']"
    #
    def self.image(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::UIElement.new(self, "#{locator}", :page, :image);end))
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
      (environment.hostname.length > 0) ?
          url = "#{environment.hostname}/#{environment.base_url}#{environment.append}" :
          url = "#{environment.base_url}#{environment.append}"
      if environment.user_id.length > 0 && environment.password.length > 0
        visit "#{environment.protocol}://#{environment.user_id}:#{environment.password}@#{url}"
      else
        visit "#{environment.protocol}://#{url}"
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
            when :visible
              actual = ui_object.visible?
            when :readonly
              actual = ui_object.read_only?
            when :checked
              actual = ui_object.checked?
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
  end
end
