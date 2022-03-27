


Feature: Basic HTML Test Page using CSS locators
  In order to xxx
  As a xxxx
  I expect to xxxx


  Background:
    Given I am on the Media Test page


  Scenario:  Verify video player play and pause controls
    When I play the video media
    Then the video should be playing
    When I pause the video media
    Then the video should be paused


  Scenario:  Verify audio player play and pause controls
    When I play the audio media
    Then the audio should be playing
    When I pause the audio media
    Then the audio should be paused


  Scenario:  Verify video player mute control
    When I mute the video media
    Then the video should be muted
    When I unmute the video media
    Then the video should be unmuted


  Scenario:  Verify audio player mute control
    When I mute the audio media
    Then the audio should be muted
    When I unmute the audio media
    Then the audio should be unmuted


  Scenario:  Verify video player volume control
    When I set the volume of the video to .5
    Then the video should have a volume of .5


  Scenario:  Verify audio player volume control
    When I set the volume of the audio to .5
    Then the audio should have a volume of .5


  Scenario:  Verify video playback speed settings
    When I play the video with a playback speed of 2x
    Then the video should play at 2x speed
    When I play the video with a playback speed of 0.25x
    Then the video should play at 0.25x speed
    When I play the video with a playback speed of 1.75x
    Then the video should play at 1.75x speed
    When I play the video with a playback speed of 0.5x
    Then the video should play at 0.5x speed
    When I play the video with a playback speed of 1.5x
    Then the video should play at 1.5x speed
    When I play the video with a playback speed of 0.75x
    Then the video should play at 0.75x speed
    When I play the video with a playback speed of 1.25x
    Then the video should play at 1.25x speed
    When I play the video with a playback speed of 1x
    Then the video should play at 1x speed


  Scenario:  Verify audio playback speed settings
    When I play the audio with a playback speed of 2x
    Then the audio should play at 2x speed
    When I play the audio with a playback speed of 0.25x
    Then the audio should play at 0.25x speed
    When I play the audio with a playback speed of 1.75x
    Then the audio should play at 1.75x speed
    When I play the audio with a playback speed of 0.5x
    Then the audio should play at 0.5x speed
    When I play the audio with a playback speed of 1.5x
    Then the audio should play at 1.5x speed
    When I play the audio with a playback speed of 0.75x
    Then the audio should play at 0.75x speed
    When I play the audio with a playback speed of 1.25x
    Then the audio should play at 1.25x speed
    When I play the audio with a playback speed of 1x
    Then the audio should play at 1x speed
