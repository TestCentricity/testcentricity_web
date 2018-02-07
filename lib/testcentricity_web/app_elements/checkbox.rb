module TestCentricity
  class AppCheckBox < AppUIElement
    def initialize(name, parent, locator, context)
      super
      @type = :checkbox
    end
  end
end
