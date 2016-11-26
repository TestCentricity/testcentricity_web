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
    #   company_logo_image.is_loaded??
    #
    def is_loaded?
      obj, = find_element
      object_not_found_exception(obj, nil)
      obj.native.attribute('complete')
    end

    # Wait until the image is fully loaded, or until the specified wait time has expired.
    #
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   company_logo_image.wait_until_loaded(5)
    #
    def wait_until_loaded(seconds = nil)
      timeout = seconds.nil? ? Capybara.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { is_loaded? }
    rescue
      raise "Image #{object_ref_message} failed to load within #{timeout} seconds" unless is_loaded?
    end
  end
end
