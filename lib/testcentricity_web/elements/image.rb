module TestCentricity
  class Image < UIElement
    def initialize(parent, locator, context)
      @parent  = parent
      @locator = locator
      @context = context
      @type    = :image
      @alt_locator = nil
    end
  end
end
