module TestCentricity
  class UIElement
    def invoke_siebel_dialog(popup)
      invoke_siebel_popup
      popup.wait_until_exists(15)
    end

    def get_siebel_object_type
      obj, _ = find_element
      object_not_found_exception(obj, 'Siebel object')
      obj.native.attribute('ot')
    end
  end
end
