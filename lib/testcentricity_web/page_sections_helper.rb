require 'test/unit'

module TestCentricity
  class PageSection
    include Capybara::DSL
    include Capybara::Node::Matchers
    include RSpec::Matchers
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
    # @param trait_name [symbol] name of trait
    # @param block [&block] trait value
    # @example
    #   trait(:section_locator)  { "//div[@class='Messaging_Applet']" }
    #   trait(:list_table_name)  { 'Messages' }
    #
    def self.trait(trait_name, &block)
      define_method(trait_name.to_s, &block)
    end

    def self.element(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::UIElement.new(self, "#{locator}", :section, nil);end))
    end

    # Define and instantiate a button UI Element for this page section.
    #
    # @param element_name [symbol] name of button object
    # @param locator [String] css selector or xpath expression that uniquely identifies object
    # @example
    #   button :checkout_button, "button.checkout_button"
    #   button :login_button,    "//input[@id='submit_button']"
    #
    def self.button(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::UIElement.new(self, "#{locator}", :section, :button);end))
    end

    # Define and instantiate a text field UI Element for this page section.
    #
    # @param element_name [symbol] name of text field object
    # @param locator [String] css selector or xpath expression that uniquely identifies object
    # @example
    #   textfield :user_id_field,  "//input[@id='UserName']"
    #   textfield :password_field, "consumer_password"
    #
    def self.textfield(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::UIElement.new(self, "#{locator}", :section, :textfield);end))
    end

    # Define and instantiate a checkbox UI Element for this page section.
    #
    # @param element_name [symbol] name of checkbox object
    # @param locator [String] css selector or xpath expression that uniquely identifies object
    # @example
    #   checkbox :remember_checkbox,     "//input[@id='RememberUser']"
    #   checkbox :accept_terms_checkbox, "accept_terms_conditions"
    #
    def self.checkbox(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::UIElement.new(self, "#{locator}", :section, :checkbox);end))
    end

    def self.label(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::UIElement.new(self, "#{locator}", :section, :label);end))
    end

    def self.link(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::UIElement.new(self, "#{locator}", :section, :link);end))
    end

    def self.table(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::UIElement.new(self, "#{locator}", :section, :table);end))
    end

    def self.selectlist(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::UIElement.new(self, "#{locator}", :section, :selectlist);end))
    end

    def self.image(element_name, locator)
      class_eval(%Q(def #{element_name.to_s};@#{element_name.to_s} ||= TestCentricity::UIElement.new(self, "#{locator}", :section, :image);end))
    end

    def self.section(section_name, class_name, locator = nil)
      class_eval(%Q(def #{section_name.to_s};@#{section_name.to_s} ||= #{class_name.to_s}.new(self, "#{locator}", :section);end))
    end

    def get_locator
      (@locator.empty? && defined?(section_locator)) ? locator = section_locator : locator = @locator
      (@context == :section && !@parent.nil? && !@parent.get_locator.nil?) ? "#{@parent.get_locator}#{locator}" : locator
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
    # @param seconds [Integer, Float] wait time in seconds
    # @example
    #   navigation_toolbar.wait_until_exists(0.5)
    #
    def wait_until_exists(seconds)
      timeout = seconds.nil? ? Capybara.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { exists? }
    rescue
      raise "Could not find section #{get_locator} after #{timeout} seconds" unless exists?
    end

    # Wait until the Section object no longer exists, or until the specified wait time has expired.
    #
    # @param seconds [Integer, Float] wait time in seconds
    # @example
    #   navigation_toolbar.wait_until_gone(5)
    #
    def wait_until_gone(seconds)
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

    private

    def find_section
      locator = get_locator
      saved_wait_time = Capybara.default_max_wait_time
      Capybara.default_max_wait_time = 0.1
      tries ||= 4
      attributes = [:text, :name, :id, :css, :xpath]
      type = attributes[tries]
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
