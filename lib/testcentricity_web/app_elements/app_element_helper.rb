require 'test/unit'

module TestCentricity
  class AppUIElement
    include Test::Unit::Assertions

    attr_reader   :parent, :locator, :context, :type, :name
    attr_accessor :alt_locator

    def initialize(name, parent, locator, context)
      @name        = name
      @parent      = parent
      @locator     = locator
      @context     = context
      @type        = nil
      @alt_locator = nil
    end

  end
end
