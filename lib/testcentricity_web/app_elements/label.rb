module TestCentricity
  class AppLabel < AppUIElement
    def initialize(name, parent, locator, context)
      super
      @type = :label
    end
  end
end
