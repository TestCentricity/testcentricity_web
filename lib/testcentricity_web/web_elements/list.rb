module TestCentricity
  class List < UIElement
    attr_accessor :list_item
    attr_accessor :selected_item

    def initialize(name, parent, locator, context)
      super
      @type = :list
      list_spec = {
        selected_item: 'li.selected',
        list_item:     'li'
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
        else
          raise "#{element} is not a recognized list element"
        end
      end
    end

    # Select the specified item in a list object. Accepts a String or Integer.
    #
    # @param item [String, Integer] text or index of item to select
    #
    # @example
    #   province_list.choose_item(2)
    #   province_list.choose_item('Manitoba')
    #
    def choose_item(item)
      obj, = find_element
      object_not_found_exception(obj, nil)
      if item.is_a?(Integer)
        obj.find(:css, "#{@list_item}:nth-of-type(#{item})", visible: true, wait: 2).click
      elsif item.is_a?(String)
        items = obj.all(@list_item).collect(&:text)
        sleep(2) unless items.include?(item)
        obj.first(:css, @list_item, text: item).click
      end
    end

    # Hover over the specified item in a list object. Accepts a String or Integer.
    #
    # @param item [String, Integer] text or index of item to hover over
    # @example
    #   province_list.hover_item(2)
    #   province_list.hover_item('Manitoba')
    #
    def hover_item(item)
      obj, = find_element
      object_not_found_exception(obj, nil)
      if item.is_a?(Integer)
        obj.find(:css, "#{@list_item}:nth-of-type(#{item})", visible: true, wait: 2).hover
      elsif item.is_a?(String)
        items = obj.all(@list_item).collect(&:text)
        sleep(2) unless items.include?(item)
        obj.first(:css, @list_item, text: item, wait: 2).hover
      end
    end

    # Return array of strings of all items in a list object.
    #
    # @return [Array]
    # @example
    #   nav_items = nav_list.get_options
    #
    def get_list_items(element_spec = nil)
      define_list_elements(element_spec) unless element_spec.nil?
      obj, = find_element
      object_not_found_exception(obj, nil)
      items = obj.all(@list_item, visible: true, minimum: 0, wait: 2).collect(&:text)

      items.map!{ |item| item.delete("\n") }
      items.map!{ |item| item.delete("\r") }
      items.map!{ |item| item.delete("\t") }
      items.map!{ |item| item.strip }
    end

    def get_list_item(index, visible = true)
      items = visible ? get_list_items : get_all_list_items
      item = items[index - 1]
      item.delete!("\n")
      item.delete!("\r")
      item.delete!("\t")
      item.strip!
    end

    # Return the number of items in a list object.
    #
    # @return [Integer]
    # @example
    #   num_nav_items = nav_list.get_item_count
    #
    def get_item_count
      obj, = find_element
      object_not_found_exception(obj, nil)
      obj.all(@list_item, visible: true, minimum: 0, wait: 2).count
    end

    alias item_count get_item_count

    def get_all_list_items(element_spec = nil)
      define_list_elements(element_spec) unless element_spec.nil?
      obj, = find_element
      object_not_found_exception(obj, nil)
      obj.all(@list_item, visible: :all).collect(&:text)
    end

    def get_all_items_count
      obj, = find_element
      object_not_found_exception(obj, nil)
      obj.all(@list_item, visible: :all).count
    end

    # Return text of first selected item in a list object.
    #
    # @return [String]
    # @example
    #   current_selection = nav_list.get_selected_item
    #
    def get_selected_item
      obj, = find_element
      object_not_found_exception(obj, nil)
      obj.first(:css, @list_item, minimum: 0) ? obj.first(:css, @selected_item).text : nil
    end

    alias selected? get_selected_item

    def verify_list_items(expected, enqueue = false)
      actual = get_list_items
      if enqueue
        ExceptionQueue.enqueue_assert_equal(expected, actual, "Expected list #{object_ref_message}")
      else
        assert_equal(expected, actual, "Expected list #{object_ref_message} to be #{expected} but found #{actual}")
      end
    end

    def get_list_row_locator(row)
      case @locator_type
      when :xpath
        "#{@locator}/#{@list_item}[#{row}]"
      when :css
        "#{@locator} > #{@list_item}:nth-of-type(#{row})"
      end
    end

    # Wait until the list's item count equals the specified value, or until the specified wait time has expired. If the wait
    # time is nil, then the wait time will be Capybara.default_max_wait_time.
    #
    # @param value [Integer or Hash] value expected or comparison hash
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   search_results_list.wait_until_item_count_is(10, 15)
    #     or
    #   search_results_list.wait_until_item_count_is({ greater_than_or_equal: 1 }, 5)
    #
    def wait_until_item_count_is(value, seconds = nil, post_exception = true)
      timeout = seconds.nil? ? Capybara.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { compare(value, get_item_count) }
    rescue
      if post_exception
        raise "Value of List #{object_ref_message} failed to equal '#{value}' after #{timeout} seconds" unless get_item_count == value
      else
        get_item_count == value
      end
    end

    # Wait until the list's item count changes to a different value, or until the specified wait time has expired. If the
    # wait time is nil, then the wait time will be Capybara.default_max_wait_time.
    #
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   search_results_list.wait_until_value_changes(5)
    #
    def wait_until_item_count_changes(seconds = nil, post_exception = true)
      value = get_item_count
      timeout = seconds.nil? ? Capybara.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { get_item_count != value }
    rescue
      if post_exception
        raise "Value of List #{object_ref_message} failed to change from '#{value}' after #{timeout} seconds" if get_item_count == value
      else
        get_item_count == value
      end
    end
  end
end
