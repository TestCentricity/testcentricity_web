module TestCentricity
  class SelectList < UIElement
    attr_accessor :list_item
    attr_accessor :selected_item
    attr_accessor :list_trigger
    attr_accessor :text_field
    attr_accessor :options_list
    attr_accessor :group_item
    attr_accessor :group_heading

    def initialize(name, parent, locator, context)
      super
      @type = :selectlist
      list_spec = {
        selected_item: "li[class*='result-selected']",
        list_item:     "li[class*='active-result']",
        list_trigger:  nil,
        text_field:    nil,
        options_list:  nil,
        group_item:    'li.group-result',
        group_heading: 'li.group-result'
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
        when :options_list
          @options_list = value
        when :group_item
          @group_item = value
        when :group_heading
          @group_heading = value
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
      @base_object, = find_element
      object_not_found_exception(@base_object, nil)

      trigger_list

      unless @options_list.nil?
        find_component(@options_list, 'drop menu')
        raise "Could not find option #{option} to choose" unless first(:css, @list_item, minimum: 0, wait: 5)

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
            options = @base_object.all(@list_item).collect(&:text)
            sleep(2) unless options.include?(option)
            first(:css, @list_item, text: option).click
          end
        end
        return
      end

      if first(:css, @list_item, minimum: 0, wait: 2)
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
            options = @base_object.all(@list_item).collect(&:text)
            sleep(2) unless options.include?(option)
            first(:css, @list_item, text: option).click
          end
        end
      else
        if option.is_a?(Array)
          option.each do |item|
            select_item(@base_object, item)
          end
        else
          select_item(@base_object, option)
        end
      end
    end

    def set(text)
      raise "A 'text_field' list element must be defined before calling the 'set' method on a selectlist object" if @text_field.nil?
      @base_object, = find_element
      object_not_found_exception(@base_object, nil)
      trigger_list

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
      @base_object, = find_element
      object_not_found_exception(@base_object, nil)
      if @options_list.nil?
        if @base_object.first(:css, @list_item, minimum: 0, wait: 2)
          @base_object.all(@list_item).collect(&:text)
        else
          @base_object.all('option', visible: :all).collect(&:text)
        end
      else
        trigger_list
        menu = find_component(@options_list, 'drop menu')
        options = menu.all(@list_item, visible: true, minimum: 0, wait: 2).collect(&:text)
        trigger_list
        options
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
      @base_object, = find_element
      object_not_found_exception(@base_object, nil)
      if @options_list.nil?
        if @base_object.first(:css, @list_item, minimum: 0, wait: 2)
          @base_object.all(@list_item).count
        else
          @base_object.all('option', visible: :all).count
        end
      else
        trigger_list
        menu = find_component(@options_list, 'drop menu')
        num_items = menu.all(@list_item, visible: true, minimum: 0, wait: 2).count
        trigger_list
        num_items
      end
    end

    alias get_item_count get_option_count

    # Return array of strings of all group headings in a select box object.
    # Supports React and Chosen select objects.
    #
    # @return [Array]
    # @example
    #   regions = team_select.get_group_headings
    #
    def get_group_headings
      @base_object, = find_element
      object_not_found_exception(@base_object, nil)
      if @options_list.nil?
        if @base_object.first(:css, @group_heading, minimum: 0, wait: 2)
          @base_object.all(@group_heading).collect(&:text)
        else
          nil
        end
      else
        trigger_list
        menu = find_component(@options_list, 'drop menu')
        groups = menu.all(@group_heading, visible: true, minimum: 0, wait: 2).collect(&:text)
        trigger_list
        groups
      end
    end

    # Return the number of groups in a select box object.
    # Supports React and Chosen select objects.
    #
    # @return [Integer]
    # @example
    #   num_regions = team_select.get_group_count
    #
    def get_group_count
      @base_object, = find_element
      object_not_found_exception(@base_object, nil)
      if @options_list.nil?
        if @base_object.first(:css, @group_item, minimum: 0, wait: 2)
          @base_object.all(@group_item).count
        else
          0
        end
      else
        trigger_list
        menu = find_component(@options_list, 'drop menu')
        num_items = menu.all(@group_item, visible: true, minimum: 0, wait: 2).count
        trigger_list
        num_items
      end
    end

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
      @base_object, = find_element
      object_not_found_exception(@base_object, nil)
      trigger_list unless @options_list.nil?
      selection = if @base_object.first(:css, @list_item, minimum: 0, wait: 1, visible: :all)
                    @base_object.first(:css, @selected_item, wait: 1, visible: :all).text
                  elsif @base_object.first(:css, @selected_item, minimum: 0, wait: 1, visible: :all)
                    @base_object.first(:css, @selected_item, visible: :all).text
                  elsif @base_object.first('option[selected]', minimum: 0, wait: 1, visible: :all)
                    @base_object.first('option[selected]', wait: 1, visible: :all).text
                  else
                    index = get_attribute(:selectedIndex).to_i
                    if index >= 0
                      options = get_options
                      options[index]
                    else
                      ''
                    end
                  end
      trigger_list unless @options_list.nil?
      selection
    end

    alias selected? get_selected_option

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

    def trigger_list
      if @list_trigger.nil?
        @base_object.click
      else
        trigger = find_component(@list_trigger, 'trigger')
        trigger.click
      end
    end
  end
end
