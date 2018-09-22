module TestCentricity
  class Audio < UIElement
    def initialize(name, parent, locator, context)
      super
      @type = :audio
    end

    # Return audio autoplay property
    #
    # @return [Boolean]
    # @example
    #   audio_player.autoplay?
    #
    def autoplay?
      obj, = find_element(visible = :all)
      object_not_found_exception(obj, :audio)
      state = obj.native.attribute('autoplay')
      state.boolean? ? state : state == 'true'
    end

    # Return audio ended property
    #
    # @return [Boolean]
    # @example
    #   audio_player.ended?
    #
    def ended?
      obj, = find_element(visible = :all)
      object_not_found_exception(obj, :audio)
      state = obj.native.attribute('ended')
      state.boolean? ? state : state == 'true'
    end

    # Return audio controls property
    #
    # @return [Boolean]
    # @example
    #   audio_player.controls?
    #
    def controls?
      obj, = find_element(visible = :all)
      object_not_found_exception(obj, :audio)
      state = obj.native.attribute('controls')
      state.boolean? ? state : state == 'true'
    end

    # Return audio loop property
    #
    # @return [Boolean]
    # @example
    #   audio_player.loop?
    #
    def loop?
      obj, = find_element(visible = :all)
      object_not_found_exception(obj, :audio)
      loop_state = obj.native.attribute('loop')
      loop_state.boolean? ? loop_state : loop_state == 'true'
    end

    # Return audio muted property
    #
    # @return [Boolean]
    # @example
    #   audio_player.muted?
    #
    def muted?
      obj, = find_element(visible = :all)
      object_not_found_exception(obj, :audio)
      mute_state = obj.native.attribute('muted')
      mute_state.boolean? ? mute_state : mute_state == 'true'
    end

    # Return audio defaultMuted property
    #
    # @return [Boolean]
    # @example
    #   audio_player.default_muted?
    #
    def default_muted?
      obj, = find_element(visible = :all)
      object_not_found_exception(obj, :audio)
      mute_state = obj.native.attribute('defaultMuted')
      mute_state.boolean? ? mute_state : mute_state == 'true'
    end

    # Return audio paused property
    #
    # @return [Boolean]
    # @example
    #   audio_player.paused?
    #
    def paused?
      obj, = find_element(visible = :all)
      object_not_found_exception(obj, :audio)
      paused_state = obj.native.attribute('paused')
      paused_state.boolean? ? paused_state : paused_state == 'true'
    end

    # Return audio seeking property
    #
    # @return [Boolean]
    # @example
    #   audio_player.seeking?
    #
    def seeking?
      obj, = find_element(visible = :all)
      object_not_found_exception(obj, :audio)
      state = obj.native.attribute('seeking')
      state.boolean? ? state : state == 'true'
    end

    # Return audio src property
    #
    # @return [String] value of src property
    # @example
    #   src_value = audio_player.src
    #
    def src
      obj, = find_element(visible = :all)
      object_not_found_exception(obj, :audio)
      obj.native.attribute('src')
    end

    # Return audio currentTime property
    #
    # @return [Integer or Float] current playback position in seconds
    # @example
    #   current_player_time = audio_player.current_time
    #
    def current_time
      obj, = find_element(visible = :all)
      object_not_found_exception(obj, :audio)
      obj.native.attribute('currentTime')
    end

    # Return audio defaultPlaybackRate property
    #
    # @return [Integer or Float] default playback speed
    # @example
    #   default_speed = audio_player.default_playback_rate
    #
    def default_playback_rate
      obj, = find_element(visible = :all)
      object_not_found_exception(obj, :audio)
      obj.native.attribute('defaultPlaybackRate')
    end

    # Return audio duration property
    #
    # @return [Integer or Float] duration of audio
    # @example
    #   how_long = audio_player.duration
    #
    def duration
      obj, = find_element(visible = :all)
      object_not_found_exception(obj, :audio)
      obj.native.attribute('duration')
    end

    # Return audio playbackRate property
    #
    # @return [Integer or Float] current playback speed
    # @example
    #   playback_speed = audio_player.playback_rate
    #
    def playback_rate
      obj, = find_element(visible = :all)
      object_not_found_exception(obj, :audio)
      obj.native.attribute('playbackRate')
    end

    # Return audio readyState property
    #
    # @return [Integer or Float] audio ready state
    # @example
    #   audio_status = audio_player.ready_state
    #
    def ready_state
      obj, = find_element(visible = :all)
      object_not_found_exception(obj, :audio)
      obj.native.attribute('readyState')
    end

    # Return audio volume property
    #
    # @return [Integer or Float] audio volume setting
    # @example
    #   volume_level = audio_player.volume
    #
    def volume
      obj, = find_element(visible = :all)
      object_not_found_exception(obj, :audio)
      obj.native.attribute('volume')
    end
  end
end
