Capybara::Node::Element.class_eval do
  def click_at(x, y)
    right = x - (native.size.width / 2)
    top = y - (native.size.height / 2)
    driver.browser.action.move_to(native).move_by(right.to_i, top.to_i).click.perform
  end

  def get_width
    native.size.width
  end

  def get_height
    native.size.height
  end
end


module TestCentricity
  class UIElement
    include Capybara::DSL
    include Test::Unit::Assertions

    attr_reader :parent, :locator, :context, :type
    attr_accessor :alt_locator

    def initialize(parent, locator, context, type = nil)
      @parent  = parent
      @locator = locator
      @context = context
      @type    = type
      @alt_locator = nil
    end

    def get_locator
      @locator
    end

    def set_alt_locator(temp_locator)
      @alt_locator = temp_locator
    end

    def clear_alt_locator
      @alt_locator = nil
    end

    def click
      obj, _ = find_element
      object_not_found_exception(obj, nil)
      begin
        obj.click
      rescue
        obj.click_at(10, 10)
      end
    end

    def double_click
      obj, _ = find_element
      object_not_found_exception(obj, nil)
      page.driver.browser.mouse.double_click(obj.native)
    end

    def click_at(x, y)
      obj, _ = find_element
      raise "Object #{@locator} not found" unless obj
      obj.click_at(x, y)
    end

    def set(value)
      obj, _ = find_element
      object_not_found_exception(obj, nil)
      obj.set(value)
    end

    def send_keys(*keys)
      obj, _ = find_element
      object_not_found_exception(obj, nil)
      obj.send_keys(*keys)
    end

    def exists?
      obj, _ = find_element
      obj != nil
    end

    def visible?
      obj, type = find_element
      exists = obj
      invisible = false
      if type == :css
        Capybara.using_wait_time 0.1 do
          # is object itself hidden with .ui-helper-hidden class?
          self_hidden = page.has_css?("#{@locator}.ui-helper-hidden")
          # is parent of object hidden, thus hiding the object?
          parent_hidden = page.has_css?(".ui-helper-hidden > #{@locator}")
          # is grandparent of object, or any other ancestor, hidden?
          other_ancestor_hidden = page.has_css?(".ui-helper-hidden * #{@locator}")
          # if any of the above conditions are true, then object is invisible
          invisible = self_hidden || parent_hidden || other_ancestor_hidden
        end
      else
        invisible = !obj.visible? if exists
      end
      # the object is visible if it exists and it is not invisible
      (exists && !invisible) ? true : false
    end

    def hidden?
      not visible?
    end

    def enabled?
      not disabled?
    end

    def disabled?
      obj, _ = find_element
      object_not_found_exception(obj, nil)
      obj.disabled?
    end

    def read_only?
      obj, _ = find_element
      object_not_found_exception(obj, nil)
      !!obj.native.attribute('readonly')
    end

    def get_max_length
      obj, _ = find_element
      object_not_found_exception(obj, nil)
      obj.native.attribute('maxlength')
    end

    def checked?
      obj, _ = find_element
      object_not_found_exception(obj, 'Checkbox')
      obj.checked?
    end

    def set_checkbox_state(state)
      obj, _ = find_element
      object_not_found_exception(obj, 'Checkbox')
      invalid_object_type_exception(obj, 'checkbox')
      obj.set(state)
    end

    def verify_check_state(state, enqueue = false)
      actual = checked?
      enqueue ?
          ExceptionQueue.enqueue_assert_equal(state, actual, "Expected #{@locator}") :
          assert_equal(state, actual, "Expected #{@locator} to be #{state} but found #{actual} instead")
    end

    def wait_until_exists(seconds)
      timeout = seconds.nil? ? Capybara.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { exists? }
    rescue
      raise "Could not find element #{@locator} after #{timeout} seconds" unless exists?
    end

    def wait_until_gone(seconds)
      timeout = seconds.nil? ? Capybara.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { !exists? }
    rescue
      raise "Element #{@locator} remained visible after #{timeout} seconds" if exists?
    end

    def wait_until_value_is(value, seconds)
      timeout = seconds.nil? ? Capybara.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { get_value == value }
    rescue
      raise "Value of UI element #{@locator} failed to equal '#{value}' after #{timeout} seconds" unless exists?
    end

    def wait_until_value_changes(seconds)
      value = get_value
      timeout = seconds.nil? ? Capybara.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { get_value != value }
    rescue
      raise "Value of UI element #{@locator} failed to change from '#{value}' after #{timeout} seconds" unless exists?
    end

    def get_value
      obj, _ = find_element
      object_not_found_exception(obj, nil)
      case obj.tag_name.downcase
        when 'input', 'select', 'textarea'
          obj.value
        else
          obj.text
      end
    end

    def verify_value(expected, enqueue = false)
      actual = get_value
      enqueue ?
          ExceptionQueue.enqueue_assert_equal(expected.strip, actual.strip, "Expected #{@locator}") :
          assert_equal(expected.strip, actual.strip, "Expected #{@locator} to display '#{expected}' but found '#{actual}'")
    end

    def hover
      obj, _ = find_element
      object_not_found_exception(obj, nil)
      obj.hover
    end

    def drag_by(right_offset, down_offset)
      obj, _ = find_element
      object_not_found_exception(obj, nil)
      obj.drag_by(right_offset, down_offset)
    end

    def attach_file(file_path)
      Capybara.ignore_hidden_elements = false
      page.attach_file(@locator, file_path)
      Capybara.ignore_hidden_elements = true
    end

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

    def get_options
      obj, _ = find_element
      object_not_found_exception(obj, nil)
      obj.all('option').collect(&:text)
    end

    def get_row_count
      wait_until_exists(5)
      row_count = page.all(:xpath, "#{@locator}/tbody/tr", :visible => :all).count
      row_count
    end

    def get_column_count
      row_count = get_row_count
      if row_count == 0
        page.all(:xpath, "#{@locator}/thead/tr/th", :visible => :all).count
      else
        (row_count == 1) ?
            page.all(:xpath, "#{@locator}/tbody/tr/td", :visible => :all).count :
            page.all(:xpath, "#{@locator}/tbody/tr[2]/td", :visible => :all).count
      end
    end

    def click_table_cell(row, column)
      row_count = get_row_count
      raise "Row #{row} exceeds number of rows (#{row_count}) in table #{@locator}" if row > row_count
      column_count = get_column_count
      raise "Column #{column} exceeds number of columns (#{column_count}) in table #{@locator}" if column > column_count
      set_table_cell_locator(row, column)
      click
      clear_alt_locator
    end

    def double_click_table_cell(row, column)
      row_count = get_row_count
      raise "Row #{row} exceeds number of rows (#{row_count}) in table #{@locator}" if row > row_count
      column_count = get_column_count
      raise "Column #{column} exceeds number of columns (#{column_count}) in table #{@locator}" if column > column_count
      set_table_cell_locator(row, column)
      double_click
      clear_alt_locator
    end

    def click_table_cell_link(row, column)
      row_count = get_row_count
      raise "Row #{row} exceeds number of rows (#{row_count}) in table #{@locator}" if row > row_count
      column_count = get_column_count
      raise "Column #{column} exceeds number of columns (#{column_count}) in table #{@locator}" if column > column_count
      set_table_cell_locator(row, column)
      saved_locator = @alt_locator
      set_alt_locator("#{@alt_locator}/a")
      set_alt_locator("#{saved_locator}/span/a") unless exists?
      # if link not present, check for text entry fields and try to dismiss by tabbing out
      unless exists?
        set_alt_locator("#{saved_locator}/input")
        set_alt_locator("#{saved_locator}/textarea") unless exists?
        send_keys(:tab) if exists?
        set_alt_locator("#{saved_locator}/a")
        set_alt_locator("#{saved_locator}/span/a") unless exists?
        send_keys(:tab) unless exists?
      end
      wait_until_exists(1)
      click
      clear_alt_locator
    end

    def get_table_row(row)
      columns = []
      row_count = get_row_count
      raise "Row #{row} exceeds number of rows (#{row_count}) in table #{@locator}" if row > row_count
      column_count = get_column_count
      (1..column_count).each do |column|
        value = ''
        set_table_cell_locator(row, column)
        saved_locator = @alt_locator
        set_alt_locator("#{saved_locator}/input")
        unless exists?
          set_alt_locator("#{saved_locator}/textarea")
          unless exists?
            set_alt_locator(saved_locator)
          end
        end
        value = get_value if exists?
        columns.push(value)
      end
      clear_alt_locator
      columns
    end

    def get_row_data(row)
      row_count = get_row_count
      raise "Row #{row} exceeds number of rows (#{row_count}) in table #{@locator}" if row > row_count
      (row > 1) ?
          set_alt_locator("#{@locator}/tbody/tr[#{row}]") :
          set_alt_locator("#{@locator}/tbody/tr")
      value = get_value if exists?
      clear_alt_locator
      value
    end

    def get_table_cell(row, column)
      row_count = get_row_count
      raise "Row #{row} exceeds number of rows (#{row_count}) in table #{@locator}" if row > row_count
      column_count = get_column_count
      raise "Column #{column} exceeds number of columns (#{column_count}) in table #{@locator}" if column > column_count
      set_table_cell_locator(row, column)
      saved_locator = @alt_locator
      set_alt_locator("#{saved_locator}/input")
      unless exists?
        set_alt_locator("#{saved_locator}/textarea")
        unless exists?
          set_alt_locator(saved_locator)
        end
      end
      value = get_value
      clear_alt_locator
      value
    end

    def verify_table_cell(row, column, expected, enqueue = false)
      actual = get_table_cell(row, column)
      enqueue ?
          ExceptionQueue.enqueue_assert_equal(expected.strip, actual.strip, "Expected #{@locator} row #{row}/column #{column}") :
          assert_equal(expected.strip, actual.strip, "Expected #{@locator} row #{row}/column #{column} to display '#{expected}' but found '#{actual}'")
    end

    def set_table_cell(row, column, value)
      row_count = get_row_count
      raise "Row #{row} exceeds number of rows (#{row_count}) in table #{@locator}" if row > row_count
      # column_count = get_column_count
      # raise "Column #{column} exceeds number of columns (#{column_count}) in table #{@locator}" if column > column_count
      set_table_cell_locator(row, column)
      click if exists?
      saved_locator = @alt_locator
      set_alt_locator("#{saved_locator}/input")
      set_alt_locator("#{saved_locator}/textarea") unless exists?
      set(value)
      clear_alt_locator
    end

    def click_header_column(column)
      column_count = get_column_count
      raise "Column #{column} exceeds number of columns (#{column_count}) in table header #{@locator}" if column > column_count
      (column > 1) ?
          set_alt_locator("#{@locator}/thead/tr/th[#{column}]") :
          set_alt_locator("#{@locator}/thead/tr/th")
      click
      clear_alt_locator
    end

    def get_header_column(column)
      column_count = get_column_count
      raise "Column #{column} exceeds number of columns (#{column_count}) in table header #{@locator}" if column > column_count
      (column > 1) ?
          set_alt_locator("#{@locator}/thead/tr/th[#{column}]") :
          set_alt_locator("#{@locator}/thead/tr/th")
      value = get_value
      clear_alt_locator
      value
    end

    def get_header_columns
      columns = []
      column_count = get_column_count
      (1..column_count).each do |column|
        (column > 1) ?
            set_alt_locator("#{@locator}/thead/tr/th[#{column}]") :
            set_alt_locator("#{@locator}/thead/tr/th")
        columns.push(get_value)
      end
      clear_alt_locator
      columns
    end

    def get_list_items(item_locator)
      obj, _ = find_element
      object_not_found_exception(obj, nil)
      obj.all(item_locator).collect(&:text)
    end

    private

    def find_element
      @alt_locator.nil? ? locator = @locator : locator = @alt_locator
      locator = "#{@parent.get_locator}#{locator}" if @context == :section && !@parent.get_locator.nil?
      saved_wait_time = Capybara.default_max_wait_time
      Capybara.default_max_wait_time = 0.01
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

    def object_not_found_exception(obj, obj_type)
      @alt_locator.nil? ? locator = @locator : locator = @alt_locator
      obj_type.nil? ? object_type = "Object" : object_type = obj_type
      raise "#{object_type} #{locator} not found" unless obj
    end

    def invalid_object_type_exception(obj, obj_type)
      unless obj.tag_name == obj_type || obj.native.attribute('type') == obj_type
        @alt_locator.nil? ? locator = @locator : locator = @alt_locator
        raise "#{locator} is not a #{obj_type} element"
      end
    end

    def set_table_cell_locator(row, column)
      row_spec = "#{@locator}/tbody/tr"
      row_spec = "#{row_spec}[#{row}]" if row > 1
      column_spec = "/td[#{column}]"
      set_alt_locator("#{row_spec}#{column_spec}")
    end
  end
end
