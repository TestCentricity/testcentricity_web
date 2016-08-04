module TestCentricity
  class UIElement
    def invoke_siebel_dialog(popup, seconds = nil)
      invoke_siebel_popup
      timeout = seconds.nil? ? 15 : seconds
      popup.wait_until_exists(timeout)
    end

    def get_siebel_object_type
      obj, _ = find_element
      object_not_found_exception(obj, 'Siebel object')
      obj.native.attribute('ot')
    end
  end
end
