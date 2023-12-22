module TestCentricity
  module Elements
    class Button < UIElement
      def initialize(name, parent, locator, context)
        super
        @type = :button
      end
    end
  end
end

