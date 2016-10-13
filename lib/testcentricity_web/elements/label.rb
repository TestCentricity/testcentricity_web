module TestCentricity
  class Label < UIElement
    def initialize(name, parent, locator, context)
      super
      @type = :label
    end
  end
end
