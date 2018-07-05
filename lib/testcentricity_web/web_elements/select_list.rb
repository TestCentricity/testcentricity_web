module TestCentricity
  class SelectList < UIElement
    attr_accessor :list_item
    attr_accessor :selected_item
    attr_accessor :list_trigger
    attr_accessor :text_field

    def initialize(name, parent, locator, context)
      super
      @type = :selectlist
      list_spec = {
          list_item:     "li[class*='active-result']",
          selected_item: "li[class*='result-selected']",
          list_trigger:  nil,
          text_field:    nil
      }
      define_list_elements(list_spec)
    end

    def define_list_elements(element_spec)
      element_spec.each do |element, value|
        case element
        when :list_item
          @list_item = value
        when :selected_item
          @selected_item = value
        when :list_trigger
          @list_trigger = value
        when :text_field
          @text_field = value
        else
          raise "#{element} is not a recognized selectlist element"
        end
      end
    end

    # Select the specified option in a select box object. Accepts a String or Hash.
    # Supports standard HTML select objects and Chosen select objects.
    #
    # @param option [String] text of option to select
    #             OR
    # @param option [Hash] :value, :index, or :text of option to select
    #
    # @example
    #   province_select.choose_option('Alberta')
    #   province_select.choose_option(value: 'AB')
    #   state_select.choose_option(index: 24)
    #   state_select.choose_option(text: 'Maryland')
    #
    def choose_option(option)
      obj, = find_element
      object_not_found_exception(obj, nil)
      if @list_trigger.nil?
        obj.click
      else
        page.find(:css, @list_trigger).click
        sleep(1)
      end
      if first(:css, @list_item, minimum: 0)
        if option.is_a?(Array)
          option.each do |item|
            page.find(:css, @list_item, text: item.strip).click
          end
        else
          if option.is_a?(Hash)
            page.find(:css, "#{@list_item}:nth-of-type(#{option[:index]})").click if option.key?(:index)
            page.find(:css, "#{@list_item}:nth-of-type(#{option[:value]})").click if option.key?(:value)
            page.find(:css, "#{@list_item}:nth-of-type(#{option[:text]})").click if option.key?(:text)
          else
            options = obj.all(@list_item).collect(&:text)
            sleep(2) unless options.include?(option)
            first(:css, @list_item, text: option).click
          end
        end
      else
        if option.is_a?(Array)
          option.each do |item|
            select_item(obj, item)
          end
        else
          select_item(obj, option)
        end
      end
    end

    def set(text)
      if @text_field.nil?
        raise "A 'text_field' list element must be defined before calling the 'set' method on a selectlist object"
      end
      obj, = find_element
      object_not_found_exception(obj, nil)
      if @list_trigger.nil?
        obj.click
      else
        page.find(:css, @list_trigger).click
      end
      page.find(:css, @text_field, wait: 2).set(text)
    end

    # Return array of strings of all options in a select box object.
    # Supports standard HTML select objects and Chosen select objects.
    #
    # @return [Array]
    # @example
    #   all_colors = color_select.get_options
    #
    def get_options
      obj, = find_element
      object_not_found_exception(obj, nil)
      if obj.first(:css, @list_item, minimum: 0)
        obj.all(@list_item).collect(&:text)
      else
        obj.all('option', visible: :all).collect(&:text)
      end
    end

    alias get_list_items get_options

    # Return the number of options in a select box object.
    # Supports standard HTML select objects and Chosen select objects.
    #
    # @return [Integer]
    # @example
    #   num_colors = color_select.get_option_count
    #
    def get_option_count
      obj, = find_element
      object_not_found_exception(obj, nil)
      if obj.first(:css, @list_item, minimum: 0)
        obj.all(@list_item).count
      else
        obj.all('option', visible: :all).count
      end
    end

    alias get_item_count get_option_count

    def verify_options(expected, enqueue = false)
      actual = get_options
      if enqueue
        ExceptionQueue.enqueue_assert_equal(expected, actual, "Expected list of options in list #{object_ref_message}")
      else
        assert_equal(expected, actual, "Expected list of options in list #{object_ref_message} to be #{expected} but found #{actual}")
      end
    end

    # Return text of first selected option in a select box object.
    # Supports standard HTML select objects and Chosen select objects.
    #
    # @return [String]
    # @example
    #   current_color = color_select.get_selected_option
    #
    def get_selected_option
      obj, = find_element
      object_not_found_exception(obj, nil)
      if obj.first(:css, @list_item, minimum: 0)
        obj.first(:css, @selected_item).text
      else
        obj.first('option[selected]', visible: :all).text
      end
    end

    alias selected? get_selected_option

    # Select the specified option in a Siebel OUI select box object.
    #
    # @param option [String] text of option to select
    # @example
    #   country_select.choose_siebel_option('Cayman Islands')
    #
    def choose_siebel_option(option)
      Capybara.wait_on_first_by_default = true
      invoke_siebel_popup
      first(:xpath, "//li[@class='ui-menu-item']", exact: true, match: :prefer_exact, text: option).click
    end

    # Return array of strings of all options in a Siebel OUI select box object.
    #
    # @return [Array]
    # @example
    #   all_countries = country_select.get_siebel_options
    #
    def get_siebel_options
      invoke_siebel_popup
      sleep(0.5)
      options = page.all(:xpath, "//li[@class='ui-menu-item']").collect(&:text)
      obj, = find_element
      obj.native.send_keys(:escape)
      options
    end

    def verify_siebel_options(expected, enqueue = false)
      invoke_siebel_popup
      sleep(0.5)
      actual = page.all(:xpath, "//li[@class='ui-menu-item']").collect(&:text)
      if enqueue
        ExceptionQueue.enqueue_assert_equal(expected, actual, "Expected list of options in list #{object_ref_message}")
      else
        assert_equal(expected, actual, "Expected list of options in list #{object_ref_message} to be #{expected} but found #{actual}")
      end
      obj, = find_element
      obj.native.send_keys(:escape)
    end

    # Is Siebel JComboBox set to read-only?
    #
    # @return [Boolean]
    # @example
    #   country_select.read_only?
    #
    def read_only?
      obj, = find_element
      object_not_found_exception(obj, nil)
      !obj.native.attribute('readonly')
    end

    private

    def select_item(obj, option)
      if option.is_a?(Hash)
        obj.find("option[value='#{option[:value]}']").click if option.key?(:value)

        if option.key?(:index)
          if @locator_type == :xpath
            obj.find(:xpath, "option[#{option[:index]}]").select_option
          else
            obj.find(:css, "option:nth-child(#{option[:index]})").select_option
          end
        end

        obj.select option[:text] if option.key?(:text)
      else
        obj.select(option, visible: :all)
      end
    end
  end
end
