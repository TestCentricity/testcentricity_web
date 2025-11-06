module TestCentricity
  module Elements
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
        obj.native.attribute('currentTime').to_f.round(1)
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
        obj.native.attribute('defaultPlaybackRate').to_f
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
        obj.native.attribute('duration').to_f.round(1)
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
        obj.native.attribute('playbackRate').to_f
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
        page.execute_script('return arguments[0].readyState', obj)
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
        wait.until do
          reset_mru_cache
          compare(value, ready_state)
        end
      rescue StandardError
        if post_exception
          raise "Ready state of media #{object_ref_message} failed to equal '#{value}' after #{timeout} seconds" unless get_value == value
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

      # Return number of text tracks of associated media
      #
      # @return [Integer] number of text tracks
      # @example
      #   num_tracks = media_player.track_count
      #
      def track_count
        obj, = find_element(visible = :all)
        object_not_found_exception(obj, @type)
        page.execute_script('return arguments[0].textTracks.length', obj)
      end

      # Return index of active text track of associated media
      #
      # @return [Integer] number of active text track
      # @example
      #   track_num = media_player.active_track
      #
      def active_track
        num_tracks = track_count
        return 0 if num_tracks.zero?

        obj, = find_element(visible = :all)
        object_not_found_exception(obj, @type)
        (0..num_tracks).each do |track|
          track_info = page.execute_script("return arguments[0].textTracks[#{track}].mode", obj)
          return track + 1 if track_info == 'showing'
        end
        0
      end

      # Return properties of active text track of associated media
      #
      # @return [Hash] properties of active text track (:kind, :label, :language, :mode)
      # @example
      #   track_info = media_player.active_track_data
      #
      def active_track_data
        active = active_track
        return nil if active.zero?

        track_data(active)
      end

      # Return properties of all text tracks of associated media
      #
      # @return [Array of Hash] properties of active text track (:kind, :label, :language, :mode)
      # @example
      #   all_track_info = media_player.all_tracks_data
      #
      def all_tracks_data
        num_tracks = track_count
        return 0 if num_tracks.zero?

        all_data = []
        (1..num_tracks).each do |track|
          all_data.push( { track => track_data(track) })
        end
        all_data
      end

      # Return properties of specified text track of associated media
      #
      # @param track [Integer] index of requested track
      # @return [Hash] properties of requested text track (:kind, :label, :language, :mode)
      # @example
      #   track_info = media_player.track_data(1)
      #
      def track_data(track)
        obj, = find_element(visible = :all)
        object_not_found_exception(obj, @type)
        track_mode = page.execute_script("return arguments[0].textTracks[#{track - 1}].mode", obj)
        track_obj = obj.find(:css, "track:nth-of-type(#{track})", visible: :all, wait: 1)
        {
          kind: track_obj[:kind],
          label: track_obj[:label],
          language: track_obj[:srclang],
          mode: track_mode
        }
      end

      # Return src property of active text track of associated media
      #
      # @return [String] src property of active text track
      # @example
      #   track_src = media_player.active_track_source
      #
      def active_track_source
        active = active_track
        return nil if active.zero?

        track_source(active)
      end

      # Return srv property of specified text track of associated media
      #
      # @param track [Integer] index of requested track
      # @return [String] src property of requested text track
      # @example
      #   track_src = media_player.track_source(2)
      #
      def track_source(track)
        obj, = find_element(visible = :all)
        object_not_found_exception(obj, @type)
        track_obj = obj.find(:css, "track:nth-of-type(#{track})", visible: :all, wait: 1)
        track_obj[:src]
      end

      # Return number of text cues of active text track of associated media
      #
      # @return [Integer] number of text cues
      # @example
      #   num_cues = media_player.active_track_cue_count
      #
      def active_track_cue_count
        active = active_track
        return nil if active.zero?

        track_cue_count(active)
      end

      # Return number of text cues of specified text track of associated media
      #
      # @param track [Integer] index of requested track
      # @return [Integer] number of text cues
      # @example
      #   num_cues = media_player.track_cue_count(2)
      #
      def track_cue_count(track)
        obj, = find_element(visible = :all)
        object_not_found_exception(obj, @type)
        page.execute_script("return arguments[0].textTracks[#{track - 1}].cues.length", obj)
       end

      # Return cue text of active text track of associated media
      #
      # @return [String] cue text of active track
      # @example
      #   caption = media_player.active_cue_text
      #
      def active_cue_text
        active = active_track
        return nil if active.zero?

        cue_text(active)
      end

      # Return text cue of specified text track of associated media
      #
      # @param track [Integer] index of requested track
      # @return [String] cue text of requested track
      # @example
      #   caption = media_player.cue_text(2)
      #
      def cue_text(track)
        obj, = find_element(visible = :all)
        object_not_found_exception(obj, @type)
        page.execute_script("return arguments[0].textTracks[#{track - 1}].activeCues[0].text", obj)
      end

      # Return properties of active text cue of associated media
      #
      # @return [Array of Hash] properties of active text cue (:text, :start, :end)
      # @example
      #   cue_data = media_player.active_cue_data
      #
      def active_cue_data
        active = active_track
        return nil if active.zero?

        obj, = find_element(visible = :all)
        object_not_found_exception(obj, @type)
        {
          text: page.execute_script('return arguments[0].textTracks[0].activeCues[0].text', obj),
          start: page.execute_script('return arguments[0].textTracks[0].activeCues[0].startTime', obj),
          end: page.execute_script('return arguments[0].textTracks[0].activeCues[0].endTime', obj)
        }
      end

      # Return all text cues of active track of associated media
      #
      # @return [Array of Hash] all text cues
      # @example
      #   all_captions = media_player.all_cues_text
      #
      def all_cues_text
        active = active_track
        return nil if active.zero?

        obj, = find_element(visible = :all)
        object_not_found_exception(obj, @type)
        num_cues = page.execute_script('return arguments[0].textTracks[0].cues.length', obj)
        all_text = []
        (1..num_cues).each do |cue|
          all_text.push( { cue - 1 => page.execute_script("return arguments[0].textTracks[0].cues[#{cue - 1}].text", obj) })
        end
        all_text
      end

      # Return properties of all cues of active track of associated media
      #
      # @return [Array of Hash] properties of all active track cues (:text, :start, :end)
      # @example
      #   cue_data = media_player.all_cues_data
      #
      def all_cues_data
        active = active_track
        return nil if active.zero?

        obj, = find_element(visible = :all)
        object_not_found_exception(obj, @type)
        num_cues = page.execute_script('return arguments[0].textTracks[0].cues.length', obj)
        all_data = []
        (1..num_cues).each do |cue|
          all_data.push(
            { cue - 1 => {
              text: page.execute_script("return arguments[0].textTracks[0].cues[#{cue - 1}].text", obj),
              start: page.execute_script("return arguments[0].textTracks[0].cues[#{cue - 1}].startTime", obj),
              end: page.execute_script("return arguments[0].textTracks[0].cues[#{cue - 1}].endTime", obj)
            }
            }
          )
        end
        all_data
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

      # Mute the media's audio
      #
      # @example
      #   media_player.mute
      #
      def mute
        obj, = find_element(visible = :all)
        object_not_found_exception(obj, @type)
        page.execute_script('arguments[0].muted = true;', obj)
      end

      # Unmute the media's audio
      #
      # @example
      #   media_player.unmute
      #
      def unmute
        obj, = find_element(visible = :all)
        object_not_found_exception(obj, @type)
        page.execute_script('arguments[0].muted = false;', obj)
      end

      # Set the media playbackRate property
      #
      # @param value [Float]
      # @example
      #   media_player.playback_rate = 1.5
      #
      def playback_rate=(value)
        obj, = find_element(visible = :all)
        object_not_found_exception(obj, @type)
        page.execute_script('arguments[0].playbackRate = arguments[1]', obj, value)
      end

      # Set the media volume property
      #
      # @param value [Float] between 0 and 1
      # @example
      #   media_player.volume = 0.5
      #
      def volume=(value)
        obj, = find_element(visible = :all)
        object_not_found_exception(obj, @type)
        page.execute_script('arguments[0].volume = arguments[1]', obj, value)
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
end
