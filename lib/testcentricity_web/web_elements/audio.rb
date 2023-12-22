module TestCentricity
  module Elements
    class Audio < Media
      def initialize(name, parent, locator, context)
        super
        @type = :audio
      end
    end
  end
end
