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
