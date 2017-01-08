module TestCentricity
  class CellButton < CellElement
    def initialize(name, parent, locator, context, table, column)
      super
      @type = :cell_button
    end
  end
end
