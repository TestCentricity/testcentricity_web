module TestCentricity
  class Link < UIElement
    def initialize(parent, locator, context)
      @parent  = parent
      @locator = locator
      @context = context
      @type    = :link
      @alt_locator = nil
    end
  end
end
