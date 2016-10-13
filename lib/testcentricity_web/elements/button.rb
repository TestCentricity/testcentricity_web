module TestCentricity
  class Button < UIElement
    def initialize(name, parent, locator, context)
      super
      @type = :button
    end
  end
end
