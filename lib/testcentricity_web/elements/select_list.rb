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
  end
end
