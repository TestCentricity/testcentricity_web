module TestCentricity
  class Label < UIElement
    def initialize(parent, locator, context)
      @parent  = parent
      @locator = locator
      @context = context
      @type    = :label
      @alt_locator = nil
    end
  end
end
