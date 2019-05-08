module TestCentricity
  class Link < UIElement
    def initialize(name, parent, locator, context)
      super
      @type = :link
    end

    # Return link object's href property
    #
    # @return [String]
    # @example
    #   contact_us_link.href
    #
    def href
      get_attribute('href')
    end
  end
end
