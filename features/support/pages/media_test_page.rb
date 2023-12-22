# Page Object class definition for Media Test page with CSS locators

class MediaTestPage < BaseTestPage
  trait(:page_name)    { 'Media Test' }
  trait(:page_locator) { 'div.media-page-body' }
  trait(:page_url)     { '/media_page.html' }
  trait(:navigator)    { header_nav.open_media_page }
  trait(:page_title)   { 'Media Page'}

  # Media Test page UI elements
  videos  video_player_1: 'video#video_player1',
          video_player_2: 'video#video_player2'
  audios  audio_player:   'audio#audio_player'

  def verify_page_ui
    super

    preload = case
              when Environ.browser == :safari
                'auto'
              when Environ.device_os == :ios && Environ.driver != :webdriver
                'auto'
              when %i[firefox firefox_headless].include?(Environ.browser)
                ''
              else
                'metadata'
              end
    video_player_1.wait_until_ready_state_is(4, 20)
    audio_player.wait_until_ready_state_is(4, 10)
    ui = {
      video_player_1 => {
        visible: true,
        paused: true,
        autoplay: false,
        loop: false,
        ended: false,
        controls: true,
        current_time: 0,
        ready_state: 4,
        default_playback_rate: 1,
        playback_rate: 1,
        seeking: false,
        default_muted: false,
        muted: false,
        volume: 1,
        preload: preload,
        poster: '',
        src: '',
        duration: 17.6,
        track_count: 0,
        active_track: 0
      },
      video_player_2 => {
        visible: true,
        paused: true,
        autoplay: false,
        loop: false,
        ended: false,
        controls: true,
        current_time: 0,
        ready_state: 4,
        default_playback_rate: 1,
        playback_rate: 1,
        seeking: false,
        default_muted: false,
        muted: false,
        volume: 1,
        preload: preload,
        poster: '',
        src: '',
        duration: 120,
        track_count: 3,
        active_track: 1,
        active_track_data: {
          kind: 'subtitles',
          label: 'English',
          language: 'en',
          mode: 'showing'
        },
        active_track_source: { ends_with: 'subtitles/sintel-en.vtt' },
        all_tracks_data: [
          { 1 => { kind: 'subtitles', label: 'English', language: 'en', mode: 'showing' } },
          { 2 => { kind: 'subtitles', label: 'Spanish', language: 'es', mode: 'disabled' } },
          { 3 => { kind: 'subtitles', label: 'German', language: 'de', mode: 'disabled' } }
        ]
      },
      audio_player => {
        visible: true,
        paused: true,
        autoplay: false,
        loop: false,
        ended: false,
        controls: true,
        current_time: 0,
        ready_state: 4,
        default_playback_rate: 1,
        playback_rate: 1,
        seeking: false,
        default_muted: false,
        muted: false,
        volume: 1,
        preload: preload,
        src: '',
        track_count: 0
      }
    }
    verify_ui_states(ui)
    unless Environ.browser == :safari
      ui = { video_player_1 => {
          width: video_player_1.video_width,
          height: video_player_1.video_height
        }
      }
      verify_ui_states(ui)
    end
  end

  def perform_action(media_type, action)
    player = dispatch_player(media_type)
    case action.downcase.to_sym
    when :play
      player.play
      player.send_keys(:enter) if player.paused?
      player.click if player.paused?
    when :pause
      player.pause
    when :mute
      player.mute
    when :unmute
      player.unmute
    else
      raise "#{action} is not a valid selector"
    end
    sleep(2)
  end

  def verify_media_state(media_type, state)
    player = dispatch_player(media_type)
    duration = player.duration
    props = case state.downcase.to_sym
            when :playing
              {
                visible: true,
                paused: false,
                ended: false,
                current_time: { greater_than: 0 },
                seeking: false
              }
            when :paused
              {
                visible: true,
                paused: true,
                ended: false,
                current_time: { greater_than: 0 },
                seeking: false
              }
            when :ended
              {
                visible: true,
                paused: true,
                ended: true,
                current_time: duration,
                seeking: false
              }
            when :muted
              {
                visible: true,
                muted: true
              }
            when :unmuted
              {
                visible: true,
                muted: false
              }
            else
              raise "#{state} is not a valid selector"
            end
    verify_ui_states(player => props)
  end

  def set_playback_rate(media_type, rate)
    player = dispatch_player(media_type)
    player.playback_rate = rate.to_f
    reset_play(player)
  end

  def verify_playback_rate(media_type, rate)
    player = dispatch_player(media_type)
    ui = {
      player => {
        playback_rate: rate.to_f,
        visible: true,
        paused: false,
        seeking: false,
        current_time: { greater_than: 0 }
      }
    }
    verify_ui_states(ui)
  end

  def set_volume(media_type, volume)
    player = dispatch_player(media_type)
    player.volume = volume.to_f
    reset_play(player)
  end

  def verify_volume(media_type, volume)
    player = dispatch_player(media_type)
    ui = {
      player => {
        volume: volume.to_f,
        visible: true,
        muted: false,
        paused: false,
        seeking: false,
        current_time: { greater_than: 0 }
      }
    }
    verify_ui_states(ui)
  end

  private

  def dispatch_player(media_type)
    player = case media_type.downcase.to_sym
             when :video
               video_player_1
             when :audio
               audio_player
             else
               raise "#{media_type} is not a valid selector"
             end
    player.wait_until_ready_state_is(4, 20)
    player
  end

  def reset_play(player)
    player.pause
    player.current_time = 0
    player.play
    player.send_keys(:enter) if player.paused?
    player.click if player.paused?
    sleep(2)
  end
end
