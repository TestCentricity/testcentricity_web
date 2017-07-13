module TestCentricity
  class CellImage < CellElement
    def initialize(name, parent, locator, context, table, column, proxy = nil)
      super
      @type = :cell_image
    end
  end
end
