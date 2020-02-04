module TestCentricity
  class Audio < Media
    def initialize(name, parent, locator, context)
      super
      @type = :audio
    end
  end
end
