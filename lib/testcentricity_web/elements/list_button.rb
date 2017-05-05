module TestCentricity
  class ListButton < ListElement
    def initialize(name, parent, locator, context, list)
      super
      @type = :list_button
    end
  end
end
