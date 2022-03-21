# Page Object class definition for Media Test page with CSS locators

class MediaTestPage < TestCentricity::PageObject
  trait(:page_name)    { 'Media Test' }
  trait(:page_locator) { 'div.media-page-body' }
  trait(:page_url)     { '/media_page.html' }

  # Media Test page UI elements
  video :video_player, 'video#video_player'
  audio :audio_player, 'audio#audio_player'
end
