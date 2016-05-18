module TestCentricity
  class Radio < UIElement
    attr_accessor :proxy

    def initialize(parent, locator, context, proxy = nil)
      @parent      = parent
      @locator     = locator
      @context     = context
      @proxy       = proxy
      @type        = :radio
      @alt_locator = nil
    end

    # Does radio button object exists?
    #
    # @return [Boolean]
    # @example
    #   accept_terms_radio.exists?
    #
    def exists?
      obj, _ = find_object(:all)
      obj != nil
    end

    # Is radio button selected?
    #
    # @return [Boolean]
    # @example
    #   accept_terms_radio.selected?
    #
    def selected?
      obj, _ = find_element(:all)
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
      obj, _ = find_element(:all)
      object_not_found_exception(obj, 'Radio')
      invalid_object_type_exception(obj, 'radio')
      if @proxy.nil?
        begin
          obj.set(state)
        rescue
          unless state == obj.checked?
            check_id = obj.native.attribute('id')
            label = first("label[for='#{check_id}']", :wait => 1, :visible => true)
            label.click unless label.nil?
          end
        end
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
