module TestCentricity
  class AppButton < AppUIElement
    def initialize(name, parent, locator, context)
      super
      @type = :button
    end
  end
end
