module TestCentricity
  class Radio < UIElement

    def initialize(parent, locator, context)
      @parent  = parent
      @locator = locator
      @context = context
      @type    = :radio
      @alt_locator = nil
    end

    # Is radio button selected?
    #
    # @return [Boolean]
    # @example
    #   accept_terms_radio.selected?
    #
    def selected?
      Capybara.ignore_hidden_elements = false
      obj, _ = find_element
      object_not_found_exception(obj, 'Radio')
      obj.checked?
    end

    # Set the select state of a radio button object.
    #
    # @param state [Boolean] true = selected / false = unselected
    # @example
    #   accept_terms_radio.set_selected_state(true)
    #
    def set_selected_state(state)
      Capybara.ignore_hidden_elements = false
      obj, _ = find_element
      object_not_found_exception(obj, 'Radio')
      invalid_object_type_exception(obj, 'radio')
      begin
        obj.set(state)
      rescue
        unless state == obj.checked?
          check_id = obj.native.attribute('id')
          label = first("label[for='#{check_id}']")
          label.click if label.exists?
        end
      end
    end

    # Set the selected state of a radio button object.
    #
    # @example
    #   accept_terms_radio.select
    #
    def select
      set_selected_state(true)
    end

    # Unselect a radio button object.
    #
    # @example
    #   accept_terms_radio.unselect
    #
    def unselect
      set_selected_state(false)
    end
  end
end
