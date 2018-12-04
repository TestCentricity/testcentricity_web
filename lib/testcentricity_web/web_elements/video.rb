module TestCentricity
  class Video < UIElement
    def initialize(name, parent, locator, context)
      super
      @type = :video
    end

    # Return video autoplay property
    #
    # @return [Boolean]
    # @example
    #   video_player.autoplay?
    #
    def autoplay?
      obj, = find_element
      object_not_found_exception(obj, nil)
      state = obj.native.attribute('autoplay')
      state.boolean? ? state : state == 'true'
    end

    # Return video ended property
    #
    # @return [Boolean]
    # @example
    #   video_player.ended?
    #
    def ended?
      obj, = find_element
      object_not_found_exception(obj, nil)
      state = obj.native.attribute('ended')
      state.boolean? ? state : state == 'true'
    end

    # Return video controls property
    #
    # @return [Boolean]
    # @example
    #   video_player.controls?
    #
    def controls?
      obj, = find_element
      object_not_found_exception(obj, nil)
      state = obj.native.attribute('controls')
      state.boolean? ? state : state == 'true'
    end

    # Return video loop property
    #
    # @return [Boolean]
    # @example
    #   video_player.loop?
    #
    def loop?
      obj, = find_element
      object_not_found_exception(obj, nil)
      loop_state = obj.native.attribute('loop')
      loop_state.boolean? ? loop_state : loop_state == 'true'
    end

    # Return video muted property
    #
    # @return [Boolean]
    # @example
    #   video_player.muted?
    #
    def muted?
      obj, = find_element
      object_not_found_exception(obj, nil)
      mute_state = obj.native.attribute('muted')
      mute_state.boolean? ? mute_state : mute_state == 'true'
    end

    # Return video defaultMuted property
    #
    # @return [Boolean]
    # @example
    #   video_player.default_muted?
    #
    def default_muted?
      obj, = find_element
      object_not_found_exception(obj, nil)
      mute_state = obj.native.attribute('defaultMuted')
      mute_state.boolean? ? mute_state : mute_state == 'true'
    end

    # Return video paused property
    #
    # @return [Boolean]
    # @example
    #   video_player.paused?
    #
    def paused?
      obj, = find_element
      object_not_found_exception(obj, nil)
      paused_state = obj.native.attribute('paused')
      paused_state.boolean? ? paused_state : paused_state == 'true'
    end

    # Return video seeking property
    #
    # @return [Boolean]
    # @example
    #   video_player.seeking?
    #
    def seeking?
      obj, = find_element
      object_not_found_exception(obj, nil)
      state = obj.native.attribute('seeking')
      state.boolean? ? state : state == 'true'
    end

    # Return video src property
    #
    # @return [String] value of src property
    # @example
    #   src_value = video_player.src
    #
    def src
      obj, = find_element
      object_not_found_exception(obj, nil)
      obj.native.attribute('src')
    end

    # Return video currentTime property
    #
    # @return [Float] current playback position in seconds
    # @example
    #   current_player_time = video_player.current_time
    #
    def current_time
      obj, = find_element
      object_not_found_exception(obj, nil)
      obj.native.attribute('currentTime').to_f
    end

    # Return video defaultPlaybackRate property
    #
    # @return [Integer or Float] default playback speed
    # @example
    #   default_speed = video_player.default_playback_rate
    #
    def default_playback_rate
      obj, = find_element
      object_not_found_exception(obj, nil)
      obj.native.attribute('defaultPlaybackRate')
    end

    # Return video duration property
    #
    # @return [Float] duration of video
    # @example
    #   how_long = video_player.duration
    #
    def duration
      obj, = find_element
      object_not_found_exception(obj, nil)
      obj.native.attribute('duration').to_f
    end

    # Return video playbackRate property
    #
    # @return [Integer or Float] current playback speed
    # @example
    #   playback_speed = video_player.playback_rate
    #
    def playback_rate
      obj, = find_element
      object_not_found_exception(obj, nil)
      obj.native.attribute('playbackRate')
    end

    # Return video readyState property
    #
    # @return [Integer or Float] video ready state
    # @example
    #   vid_status = video_player.ready_state
    #
    def ready_state
      obj, = find_element
      object_not_found_exception(obj, nil)
      obj.native.attribute('readyState')
    end

    # Return video volume property
    #
    # @return [Integer or Float] video volume setting
    # @example
    #   volume_level = video_player.volume
    #
    def volume
      obj, = find_element
      object_not_found_exception(obj, nil)
      obj.native.attribute('volume')
    end

    # Set the video currentTime property
    #
    # @param value [Float] time in seconds
    # @example
    #   video_player.current_time = 1.5
    #
    def current_time=(value)
      obj, = find_element
      object_not_found_exception(obj, nil)
      page.execute_script('arguments[0].currentTime = arguments[1]', obj, value)
    end

    # Play the video
    #
    # @example
    #   video_player.play
    #
    def play
      obj, = find_element
      object_not_found_exception(obj, nil)
      page.execute_script('arguments[0].play()', obj)
    end

    # Pause the video
    #
    # @example
    #   video_player.pause
    #
    def pause
      obj, = find_element
      object_not_found_exception(obj, nil)
      page.execute_script('arguments[0].pause()', obj)
    end
  end
end
