module TestCentricity
  class Media < UIElement
    # Return media autoplay property
    #
    # @return [Boolean]
    # @example
    #   media_player.autoplay?
    #
    def autoplay?
      obj, = find_element(visible = :all)
      object_not_found_exception(obj, @type)
      state = obj.native.attribute('autoplay')
      state.boolean? ? state : state == 'true'
    end

    # Return media ended property
    #
    # @return [Boolean]
    # @example
    #   media_player.ended?
    #
    def ended?
      obj, = find_element(visible = :all)
      object_not_found_exception(obj, @type)
      state = obj.native.attribute('ended')
      state.boolean? ? state : state == 'true'
    end

    # Return media controls property
    #
    # @return [Boolean]
    # @example
    #   media_player.controls?
    #
    def controls?
      obj, = find_element(visible = :all)
      object_not_found_exception(obj, @type)
      state = obj.native.attribute('controls')
      state.boolean? ? state : state == 'true'
    end

    # Return media loop property
    #
    # @return [Boolean]
    # @example
    #   media_player.loop?
    #
    def loop?
      obj, = find_element(visible = :all)
      object_not_found_exception(obj, @type)
      loop_state = obj.native.attribute('loop')
      loop_state.boolean? ? loop_state : loop_state == 'true'
    end

    # Return media muted property
    #
    # @return [Boolean]
    # @example
    #   media_player.muted?
    #
    def muted?
      obj, = find_element(visible = :all)
      object_not_found_exception(obj, @type)
      mute_state = obj.native.attribute('muted')
      mute_state.boolean? ? mute_state : mute_state == 'true'
    end

    # Return media defaultMuted property
    #
    # @return [Boolean]
    # @example
    #   media_player.default_muted?
    #
    def default_muted?
      obj, = find_element(visible = :all)
      object_not_found_exception(obj, @type)
      mute_state = obj.native.attribute('defaultMuted')
      mute_state.boolean? ? mute_state : mute_state == 'true'
    end

    # Return media paused property
    #
    # @return [Boolean]
    # @example
    #   media_player.paused?
    #
    def paused?
      obj, = find_element(visible = :all)
      object_not_found_exception(obj, @type)
      paused_state = obj.native.attribute('paused')
      paused_state.boolean? ? paused_state : paused_state == 'true'
    end

    # Return media seeking property
    #
    # @return [Boolean]
    # @example
    #   media_player.seeking?
    #
    def seeking?
      obj, = find_element(visible = :all)
      object_not_found_exception(obj, @type)
      state = obj.native.attribute('seeking')
      state.boolean? ? state : state == 'true'
    end

    # Return media src property
    #
    # @return [String] value of src property
    # @example
    #   src_value = media_player.src
    #
    def src
      obj, = find_element(visible = :all)
      object_not_found_exception(obj, @type)
      obj.native.attribute('src')
    end

    # Return media currentTime property
    #
    # @return [Float] current playback position in seconds
    # @example
    #   current_player_time = media_player.current_time
    #
    def current_time
      obj, = find_element(visible = :all)
      object_not_found_exception(obj, @type)
      obj.native.attribute('currentTime').to_f
    end

    # Return media defaultPlaybackRate property
    #
    # @return [Integer or Float] default playback speed
    # @example
    #   default_speed = media_player.default_playback_rate
    #
    def default_playback_rate
      obj, = find_element(visible = :all)
      object_not_found_exception(obj, @type)
      obj.native.attribute('defaultPlaybackRate')
    end

    # Return media duration property
    #
    # @return [Float] duration of media
    # @example
    #   how_long = media_player.duration
    #
    def duration
      obj, = find_element(visible = :all)
      object_not_found_exception(obj, @type)
      obj.native.attribute('duration').to_f
    end

    # Return media playbackRate property
    #
    # @return [Integer or Float] current playback speed
    # @example
    #   playback_speed = media_player.playback_rate
    #
    def playback_rate
      obj, = find_element(visible = :all)
      object_not_found_exception(obj, @type)
      obj.native.attribute('playbackRate')
    end

    # Return media readyState property
    #
    # @return [Integer] media ready state
    #   0 = HAVE_NOTHING - no information whether or not the audio/video is ready
    #   1 = HAVE_METADATA - metadata for the audio/video is ready
    #   2 = HAVE_CURRENT_DATA - data for the current playback position is available, but not enough data to play next frame/millisecond
    #   3 = HAVE_FUTURE_DATA - data for the current and at least the next frame is available
    #   4 = HAVE_ENOUGH_DATA - enough data available to start playing
    # @example
    #   media_status = media_player.ready_state
    #
    def ready_state
      obj, = find_element(visible = :all)
      object_not_found_exception(obj, @type)
      obj.native.attribute('readyState').to_i
    end

    # Wait until the media object's readyState value equals the specified value, or until the specified wait time has expired. If the wait
    # time is nil, then the wait time will be Capybara.default_max_wait_time.
    #
    # @param value [Integer] value expected
    # @param seconds [Integer or Float] wait time in seconds
    # @example
    #   media_player.wait_until_ready_state_is(4, 5)
    #
    def wait_until_ready_state_is(value, seconds = nil, post_exception = true)
      timeout = seconds.nil? ? Capybara.default_max_wait_time : seconds
      wait = Selenium::WebDriver::Wait.new(timeout: timeout)
      wait.until { ready_state == value }
    rescue StandardError
      if post_exception
        raise "Ready state of Audio #{object_ref_message} failed to equal '#{value}' after #{timeout} seconds" unless get_value == value
      else
        ready_state == value
      end
    end

    # Return media volume property
    #
    # @return [Float] media volume setting
    # @example
    #   volume_level = media_player.volume
    #
    def volume
      obj, = find_element(visible = :all)
      object_not_found_exception(obj, @type)
      obj.native.attribute('volume').to_f
    end

    # Set the media currentTime property
    #
    # @param value [Float] time in seconds
    # @example
    #   media_player.current_time = 1.5
    #
    def current_time=(value)
      obj, = find_element(visible = :all)
      object_not_found_exception(obj, @type)
      page.execute_script('arguments[0].currentTime = arguments[1]', obj, value)
    end

    # Play the media
    #
    # @example
    #   media_player.play
    #
    def play
      obj, = find_element(visible = :all)
      object_not_found_exception(obj, @type)
      page.execute_script('arguments[0].play()', obj)
    end

    # Pause the media
    #
    # @example
    #   media_player.pause
    #
    def pause
      obj, = find_element(visible = :all)
      object_not_found_exception(obj, @type)
      page.execute_script('arguments[0].pause()', obj)
    end

    # Return media crossorigin property
    #
    # @return crossorigin value
    # @example
    #   with_creds = media_player.crossorigin == 'use-credentials'
    #
    def crossorigin
      obj, = find_element
      object_not_found_exception(obj, @type)
      obj.native.attribute('crossorigin')
    end

    # Return media preload property
    #
    # @return preload value
    # @example
    #   preload = media_player.preload
    #
    def preload
      obj, = find_element
      object_not_found_exception(obj, @type)
      obj.native.attribute('preload')
    end
  end
end
