@!grid @!chrome_headless @!edge_headless


Feature: HTML5 Audio/Video Test Page using CSS locators
  In order to ensure comprehensive support for HTML5 Audio and Video media elements
  As a developer of the TestCentricity web gem
  I expect to validate the interaction and verification capabilities of media UI elements


  Background:
    Given I am on the Media Test page

@!ios
  Scenario:  Verify video player play and pause controls
    When I play the video media
    Then the video media should be playing
    When I pause the video media
    Then the video media should be paused

@!ios
  Scenario:  Verify audio player play and pause controls
    When I play the audio media
    Then the audio media should be playing
    When I pause the audio media
    Then the audio media should be paused


  Scenario:  Verify video player mute control
    When I mute the video media
    Then the video media should be muted
    When I unmute the video media
    Then the video media should be unmuted


  Scenario:  Verify audio player mute control
    When I mute the audio media
    Then the audio media should be muted
    When I unmute the audio media
    Then the audio media should be unmuted

@!ios
  Scenario:  Verify video player volume control
    When I set the volume of the video to .5
    Then the video should have a volume of .5

@!ios
  Scenario:  Verify audio player volume control
    When I set the volume of the audio to .5
    Then the audio should have a volume of .5

@!ios
  Scenario:  Verify video playback speed settings
    When I play the video with a playback speed of 2x
    Then the video should play at 2x speed
    When I play the video with a playback speed of 0.5x
    Then the video should play at 0.5x speed
    When I play the video with a playback speed of 1x
    Then the video should play at 1x speed

@!ios
  Scenario:  Verify audio playback speed settings
    When I play the audio with a playback speed of 2x
    Then the audio should play at 2x speed
    When I play the audio with a playback speed of 0.5x
    Then the audio should play at 0.5x speed
    When I play the audio with a playback speed of 1x
    Then the audio should play at 1x speed
