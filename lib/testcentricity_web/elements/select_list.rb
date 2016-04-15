module TestCentricity
  class SelectList < UIElement
    def initialize(parent, locator, context)
      @parent  = parent
      @locator = locator
      @context = context
      @type    = :selectlist
      @alt_locator = nil
    end

    # Select the specified option in a select box object.
    # Supports standard HTML select objects and Chosen select objects.
    #
    # @param option [String] text of option to select
    # @example
    #   province_select.choose_option('Nova Scotia')
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
      elsif first(:xpath, "//ul/li")
        first(:xpath, "//ul/li", text: option).click
      else
        if option.is_a?(Array)
          option.each do |item|
            obj.select item
          end
        else
          obj.select option
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
        obj.all('option').collect(&:text)
      end
    end

    def verify_options(expected, enqueue = false)
      actual = get_options
      enqueue ?
          ExceptionQueue.enqueue_assert_equal(expected, actual, "Expected list of options in list #{@locator}") :
          assert_equal(expected, actual, "Expected list of options in list #{@locator} to be #{expected} but found #{actual}")
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
        obj.first('option[selected]').text
      end
    end

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
          ExceptionQueue.enqueue_assert_equal(expected, actual, "Expected list of options in list #{@locator}") :
          assert_equal(expected, actual, "Expected list of options in list #{@locator} to be #{expected} but found #{actual}")
      obj, _ = find_element
      obj.native.send_keys(:escape)
    end
  end
end
