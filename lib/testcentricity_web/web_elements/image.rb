module TestCentricity
  class Image < UIElement
    def initialize(name, parent, locator, context)
      super
      @type = :image
    end

    # Is image loaded?
    #
    # @return [Boolean]
    # @example
    #   company_logo_image.is_loaded?
    #
    def loaded?
      obj, = find_element
      object_not_found_exception(obj, nil)
      obj.native.attribute('complete')
    end

    alias is_loaded? loaded?

    # Is image broken?
    #
    # @return [Boolean]
    # @example
    #   company_logo_image.broken?
    #
    def broken?
      obj, = find_element
      object_not_found_exception(obj, nil)
      result = page.execute_script(
        'return arguments[0].complete && typeof arguments[0].naturalWidth != "undefined" && arguments[0].naturalWidth > 0',
        obj
      )
      !result
    end

    # Wait until the image is fully loaded, or until the specified wait time has expired.
    #
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   company_logo_image.wait_until_loaded(5)
    #
    def wait_until_loaded(seconds = nil, post_exception = true)
      timeout = seconds.nil? ? Capybara.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { is_loaded? }
    rescue
      if post_exception
        raise "Image #{object_ref_message} failed to load within #{timeout} seconds" unless loaded?
      else
        loaded?
      end
    end

    # Return image alt property
    #
    # @return [String] value of alt property
    # @example
    #   alt_value = company_logo_image.alt
    #
    def alt
      obj, = find_element
      object_not_found_exception(obj, nil)
      obj.native.attribute('alt')
    end

    # Return image src property
    #
    # @return [String] value of src property
    # @example
    #   src_value = company_logo_image.src
    #
    def src
      obj, = find_element
      object_not_found_exception(obj, nil)
      obj.native.attribute('src')
    end
  end
end
