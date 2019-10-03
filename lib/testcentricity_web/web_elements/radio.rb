module TestCentricity
  class Radio < UIElement
    attr_accessor :proxy

    def initialize(name, parent, locator, context, proxy = nil)
      @name        = name
      @parent      = parent
      @locator     = locator
      @context     = context
      @alt_locator = nil
      @proxy       = proxy
      @type        = :radio
      set_locator_type
    end

    # Does radio button object exists?
    #
    # @return [Boolean]
    # @example
    #   accept_terms_radio.exists?
    #
    def exists?
      obj, = find_object(:all)
      obj != nil
    end

    # Is radio button selected?
    #
    # @return [Boolean]
    # @example
    #   accept_terms_radio.selected?
    #
    def selected?
      obj, = find_element(:all)
      object_not_found_exception(obj, 'Radio')
      obj.checked?
    end

    # Is radio button visible?
    #
    # @return [Boolean]
    # @example
    #   accept_terms_radio.visible?
    #
    def visible?
      @proxy.nil? ? super : @proxy.visible?
    end

    # Is radio button disabled (not enabled)?
    #
    # @return [Boolean]
    # @example
    #   accept_terms_radio.disabled?
    #
    def disabled?
      visibility = @proxy.nil? ? true : :all
      obj, type = find_element(visibility)
      object_not_found_exception(obj, type)
      obj.disabled?
    end

    # Return radio button caption
    #
    # @return [Boolean]
    # @example
    #   accept_terms_radio.get_value
    #
    def get_value
      @proxy.nil? ? super : @proxy.get_value
    end

    # Set the select state of a radio button object.
    #
    # @param state [Boolean] true = selected / false = unselected
    # @example
    #   accept_terms_radio.set_selected_state(true)
    #
    def set_selected_state(state)
      obj, = find_element(:all)
      object_not_found_exception(obj, 'Radio')
      invalid_object_type_exception(obj, 'radio')
      if @proxy.nil?
        obj.set(state)
      else
        @proxy.click unless state == obj.checked?
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
