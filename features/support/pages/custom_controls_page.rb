# Page Object class definition for Custom Controls page with CSS locators

class CustomControlsPage < BaseTestPage
  trait(:page_name)    { 'Custom Controls' }
  trait(:page_locator) { 'div.custom-controls-page-body' }
  trait(:page_url)     { '/custom_controls_page.html' }
  trait(:navigator)    { header_nav.open_custom_controls_page }
  trait(:page_title)   { 'Custom Controls Page'}

  def verify_page_ui
    super
  end
end
