module TestCentricity
  class Button < UIElement
    def initialize(parent, locator, context)
      @parent  = parent
      @locator = locator
      @context = context
      @type    = :button
      @alt_locator = nil
    end
  end
end
