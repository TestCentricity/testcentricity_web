module TestCentricity
  class AppTextField < AppUIElement
    def initialize(name, parent, locator, context)
      super
      @type = :textfield
    end
  end
end
