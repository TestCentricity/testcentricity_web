# Page Object class definition for Base Test page

class BaseTestPage < TestCentricity::PageObject
  # Base Test page UI elements
  label    :header_label, 'h2'
  sections header_nav:    NavHeader

  def navigate_to
    navigator
  end

  def verify_page_ui
    # verify page title and header
    ui = {
      self         => { exists: true, secure: false, title: page_title },
      header_label => { visible: true, caption: page_title }
    }
    verify_ui_states(ui)
    # verify header navigation bar
    header_nav.verify_nav_bar
  end
end
