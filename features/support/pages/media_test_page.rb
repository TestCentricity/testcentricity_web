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
              when Environ.device_os == :ios && Environ.driver != :webdriver
                'auto'
              when %i[firefox firefox_headless safari].include?(Environ.browser)
                'auto'
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
        ],
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

  def set_current_time(media_type, seconds)
    player = dispatch_player(media_type)
    player.current_time = seconds.to_f
  end

  def verify_caption_track(media_type)
    player = dispatch_player(media_type)
    ui = {
      player => {
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
        ],
        active_track_cue_count: 14,
        active_cue_text: '<v Test>[Test]</v>',
        active_cue_data: {
          text: '<v Test>[Test]</v>',
          start: 0,
          end: 12
        },
        all_cues_text: [
          { 0 => '<v Test>[Test]</v>' },
          { 1 => 'This blade has a dark past.' },
          { 2 => 'It has shed much innocent blood.' },
          { 3 => "You're a fool for traveling alone,\nso completely unprepared." },
          { 4 => 'You\'re lucky your blood\'s still flowing.' },
          { 5 => 'Thank you.' }, { 6 => "So..." },
          { 7 => "What brings you to\nthe land of the gatekeepers?" },
          { 8 => 'I\'m searching for someone.' },
          { 9 => "Someone very dear?\nA kindred spirit?" },
          { 10 => 'A dragon.' },
          { 11 => 'A dangerous quest for a lone hunter.' },
          { 12 => "I've been alone for\nas long as I can remember." },
          { 13 => 'We\'re almost done. Shhh...' }
        ],
        all_cues_data: [
          { 0 =>
              {
                text: '<v Test>[Test]</v>',
                start: 0,
                end: 12
              },
          },
          { 1 =>
              {
                text: 'This blade has a dark past.',
                start: 18.7,
                end: 21.5
              },
          },
          { 2 =>
              {
                text: 'It has shed much innocent blood.',
                start: 22.8,
                end: 26.8
              },
          },
          { 3 =>
              {
                text: "You're a fool for traveling alone,\nso completely unprepared.",
                start: 29,
                end: 32.45
              },
          },
          { 4 =>
              {
                text: 'You\'re lucky your blood\'s still flowing.',
                start: 32.75,
                end: 35.8
              },
          },
          { 5 =>
              {
                text: 'Thank you.',
                start: 36.25,
                end: 37.3
              },
          },
          { 6 =>
              {
                text: "So...",
                start: 38.5,
                end: 40
              },
          },
          { 7 =>
              {
                text: "What brings you to\nthe land of the gatekeepers?",
                start: 40.4,
                end: 44.8
              },
          },
          { 8 =>
              {
                text: 'I\'m searching for someone.',
                start: 46,
                end: 48.5
              },
          },
          { 9 =>
              {
                text: "Someone very dear?\nA kindred spirit?",
                start: 49,
                end: 53.2
              },
          },
          { 10 =>
              {
                text: 'A dragon.',
                start: 54.4,
                end: 56
              },
          },
          { 11 =>
              {
                text: 'A dangerous quest for a lone hunter.',
                start: 58.85,
                end: 61.75
              },
          },
          { 12 =>
              {
                text: "I've been alone for\nas long as I can remember.",
                start: 62.95,
                end: 65.87
              },
          },
          { 13 =>
              {
                text: 'We\'re almost done. Shhh...',
                start: 118.25,
                end: 119.5
              }
          }
        ]
      }
    }
    verify_ui_states(ui)
  end

  def verify_caption(media_type)
    player = dispatch_player(media_type)
    ui = {
      player => {
        visible: true,
        paused: true,
        ready_state: 4,
        current_time: 20,
        active_cue_text: 'This blade has a dark past.',
        active_cue_data: {
          text: 'This blade has a dark past.',
          start: 18.7,
          end: 21.5
        }
      }
    }
    verify_ui_states(ui)
  end

  private

  def dispatch_player(media_type)
    player = case media_type.gsub(/\s+/, '_').downcase.to_sym
             when :video
               video_player_1
             when :audio
               audio_player
             when :video_with_captions
               video_player_2
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
