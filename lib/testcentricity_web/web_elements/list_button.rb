module TestCentricity
  class ListButton < ListElement
    def initialize(name, parent, locator, context, list, proxy = nil)
      super
      @type = :list_button
    end
  end
end
