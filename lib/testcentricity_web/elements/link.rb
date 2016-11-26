module TestCentricity
  class Link < UIElement
    def initialize(name, parent, locator, context)
      super
      @type = :link
    end
  end
end
