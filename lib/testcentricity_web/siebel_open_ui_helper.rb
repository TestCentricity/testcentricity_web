module TestCentricity
  class UIElement
    def set_siebel_checkbox_state(state)
      obj, _ = find_element
      object_not_found_exception(obj, 'Siebel checkbox')
      raise "#{locator} is not a Siebel CheckBox object" unless get_siebel_object_type == 'JCheckBox'
      expected = state.to_bool
      obj.click unless expected == obj.checked?
    end

    def choose_siebel_option(option)
      Capybara.wait_on_first_by_default = true
      invoke_siebel_popup
      first(:xpath, "//li[@class='ui-menu-item']", :exact => true, :match => :prefer_exact,text: option).click
    end

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

    def invoke_siebel_dialog(popup)
      invoke_siebel_popup
      popup.wait_until_exists(15)
    end

    def is_table_row_expanded?(row, column)
      row_count = get_row_count
      raise "Row #{row} exceeds number of rows (#{row_count}) in table #{@locator}" if row > row_count
      column_count = get_column_count
      raise "Column #{column} exceeds number of columns (#{column_count}) in table #{@locator}" if column > column_count
      set_table_cell_locator(row, column)
      saved_locator = @alt_locator
      set_alt_locator("#{@alt_locator}//div[@class='ui-icon ui-icon-triangle-1-s tree-minus treeclick']")
      if exists?
        expanded = true
      else
        set_alt_locator("#{saved_locator}//div[@class='ui-icon ui-icon-triangle-1-e tree-plus treeclick']")
        if exists?
          expanded = false
        else
          raise "Row #{row}/Column #{column} of table #{@locator} does not contain a disclosure triangle"
        end
      end
      clear_alt_locator
      expanded
    end

    def expand_table_row(row, column)
      unless is_table_row_expanded?(row, column)
        set_table_cell_locator(row, column)
        set_alt_locator("#{saved_locator}//div[@class='ui-icon ui-icon-triangle-1-e tree-plus treeclick']")
        click if exists?
        clear_alt_locator
      end
    end

    def collapse_table_row(row, column)
      if is_table_row_expanded?(row, column)
        set_table_cell_locator(row, column)
        set_alt_locator("#{saved_locator}//div[@class='ui-icon ui-icon-triangle-1-e tree-minus treeclick']")
        click if exists?
        clear_alt_locator
      end
    end

    def get_siebel_object_type
      obj, _ = find_element
      object_not_found_exception(obj, 'Siebel object')
      obj.native.attribute('ot')
    end

    private

    def invoke_siebel_popup
      obj, _ = find_element
      object_not_found_exception(obj, 'Siebel object')
      trigger_name = obj.native.attribute('aria-describedby').strip
      trigger = "//span[@id='#{trigger_name}']"
      trigger = "#{@parent.get_locator}#{trigger}" if @context == :section && !@parent.get_locator.nil?
      first(:xpath, trigger).click
    end
  end
end
