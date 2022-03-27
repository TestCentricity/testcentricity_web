# Page Object class definition for Custom Controls page with CSS locators

class CustomControlsPage < BaseTestPage
  trait(:page_name)    { 'Custom Controls' }
  trait(:page_locator) { 'div.custom-controls-page-body' }
  trait(:page_url)     { '/custom_controls_page.html' }
  trait(:navigator)    { header_nav.open_custom_controls_page }

  def verify_page_ui
    ui = {
      self         => { exists: true, secure: false, title: 'Custom Controls Page' },
      header_label => { visible: true, caption: 'Custom Controls Page' }
    }
    verify_ui_states(ui)
  end
end
