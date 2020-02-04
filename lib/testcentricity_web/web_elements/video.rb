module TestCentricity
  class Video < Media
    def initialize(name, parent, locator, context)
      super
      @type = :video
    end

    # Return video Height property
    #
    # @return [Integer] video height
    # @example
    #   height = video_player.video_height
    #
    def video_height
      obj, = find_element
      object_not_found_exception(obj, :video)
      obj.native.attribute('videoHeight')
    end

    # Return video Width property
    #
    # @return [Integer] video width
    # @example
    #   width = video_player.video_width
    #
    def video_width
      obj, = find_element
      object_not_found_exception(obj, :video)
      obj.native.attribute('videoWidth')
    end

    # Return video poster property
    #
    # @return poster value
    # @example
    #   poster = video_player.poster
    #
    def poster
      obj, = find_element
      object_not_found_exception(obj, :video)
      obj.native.attribute('poster')
    end
  end
end
