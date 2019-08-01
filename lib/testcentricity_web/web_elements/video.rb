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
    # @return [Integer] video ready state
    #   0 = HAVE_NOTHING - no information whether or not the audio/video is ready
    #   1 = HAVE_METADATA - metadata for the audio/video is ready
    #   2 = HAVE_CURRENT_DATA - data for the current playback position is available, but not enough data to play next frame/millisecond
    #   3 = HAVE_FUTURE_DATA - data for the current and at least the next frame is available
    #   4 = HAVE_ENOUGH_DATA - enough data available to start playing
    # @example
    #   vid_status = video_player.ready_state
    #
    def ready_state
      obj, = find_element
      object_not_found_exception(obj, nil)
      obj.native.attribute('readyState').to_i
    end

    # Wait until the video object's readyState value equals the specified value, or until the specified wait time has expired. If the wait
    # time is nil, then the wait time will be Capybara.default_max_wait_time.
    #
    # @param value [Integer] value expected
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   video_player.wait_until_ready_state_is(4, 5)
    #
    def wait_until_ready_state_is(value, seconds = nil, post_exception = true)
      timeout = seconds.nil? ? Capybara.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { ready_state == value }
    rescue StandardError
      if post_exception
        raise "Ready state of Video #{object_ref_message} failed to equal '#{value}' after #{timeout} seconds" unless get_value == value
      else
        ready_state == value
      end
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

    # Return video Height property
    #
    # @return [Integer] video height
    # @example
    #   height = video_player.video_height
    #
    def video_height
      obj, = find_element
      object_not_found_exception(obj, nil)
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
      object_not_found_exception(obj, nil)
      obj.native.attribute('videoWidth')
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
