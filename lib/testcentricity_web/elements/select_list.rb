module TestCentricity
  class SelectList < UIElement
    attr_accessor :list_item
    attr_accessor :selected_item

    def initialize(name, parent, locator, context)
      super
      @type = :selectlist
      list_spec = {
          :list_item     => 'option',
          :selected_item => 'option[selected]'
      }
      define_list_elements(list_spec)
    end

    def define_list_elements(element_spec)
      element_spec.each do | element, value |
        case element
          when :list_item
            @list_item = value
          when :selected_item
            @selected_item = value
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
    #   province_select.choose_option(:value => 'AB')
    #   state_select.choose_option(:index => 24)
    #   state_select.choose_option(:text => 'Maryland')
    #
    def choose_option(option)
      obj, _ = find_element
      object_not_found_exception(obj, nil)
      obj.click
      if first(:css, 'li.active-result')
        if option.is_a?(Array)
          option.each do |item|
            page.find(:css, 'li.active-result', text: item.strip).click
          end
        else
          first(:css, 'li.active-result', text: option).click
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

    # Return array of strings of all options in a select box object.
    # Supports standard HTML select objects and Chosen select objects.
    #
    # @return [Array]
    # @example
    #   all_colors = color_select.get_options
    #
    def get_options
      obj, _ = find_element
      object_not_found_exception(obj, nil)
      if first(:css, 'li.active-result')
        obj.all('li.active-result').collect(&:text)
      else
        obj.all(@list_item).collect(&:text)
      end
    end

    alias :get_list_items :get_options

    # Return the number of options in a select box object.
    # Supports standard HTML select objects and Chosen select objects.
    #
    # @return [Integer]
    # @example
    #   num_colors = color_select.get_option_count
    #
    def get_option_count
      obj, _ = find_element
      object_not_found_exception(obj, nil)
      if first(:css, 'li.active-result')
        obj.all('li.active-result').count
      else
        obj.all(@list_item).count
      end
    end

    alias :get_item_count :get_option_count

    def verify_options(expected, enqueue = false)
      actual = get_options
      enqueue ?
          ExceptionQueue.enqueue_assert_equal(expected, actual, "Expected list of options in list #{object_ref_message}") :
          assert_equal(expected, actual, "Expected list of options in list #{object_ref_message} to be #{expected} but found #{actual}")
    end

    # Return text of first selected option in a select box object.
    # Supports standard HTML select objects and Chosen select objects.
    #
    # @return [String]
    # @example
    #   current_color = color_select.get_selected_option
    #
    def get_selected_option
      obj, _ = find_element
      object_not_found_exception(obj, nil)
      if first(:css, 'li.active-result')
        obj.first("//li[contains(@class, 'result-selected')]").text
      else
        obj.first(@selected_item).text
      end
    end

    alias :selected? :get_selected_option

    # Select the specified option in a Siebel OUI select box object.
    #
    # @param option [String] text of option to select
    # @example
    #   country_select.choose_siebel_option('Cayman Islands')
    #
    def choose_siebel_option(option)
      Capybara.wait_on_first_by_default = true
      invoke_siebel_popup
      first(:xpath, "//li[@class='ui-menu-item']", :exact => true, :match => :prefer_exact, text: option).click
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
      obj, _ = find_element
      obj.native.send_keys(:escape)
      options
    end

    def verify_siebel_options(expected, enqueue = false)
      invoke_siebel_popup
      sleep(0.5)
      actual = page.all(:xpath, "//li[@class='ui-menu-item']").collect(&:text)
      enqueue ?
          ExceptionQueue.enqueue_assert_equal(expected, actual, "Expected list of options in list #{object_ref_message}") :
          assert_equal(expected, actual, "Expected list of options in list #{object_ref_message} to be #{expected} but found #{actual}")
      obj, _ = find_element
      obj.native.send_keys(:escape)
    end

    # Is Siebel JComboBox set to read-only?
    #
    # @return [Boolean]
    # @example
    #   country_select.read_only?
    #
    def read_only?
      obj, _ = find_element
      object_not_found_exception(obj, nil)
      !!obj.native.attribute('readonly')
    end

    private

    def select_item(obj, option)
      if option.is_a?(Hash)
        obj.find("option[value='#{option[:value]}']").click if option.has_key?(:value)
        obj.find(:xpath, "option[#{option[:index]}]").select_option if option.has_key?(:index)
        obj.select option[:text] if option.has_key?(:text)
      else
        obj.select option
      end
    end
  end
end
