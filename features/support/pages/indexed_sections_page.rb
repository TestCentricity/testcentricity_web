# Page Object class definition for Indexed Sections page with CSS locators

class IndexedSectionsPage < BaseTestPage
  trait(:page_name)    { 'Indexed Sections' }
  trait(:page_locator) { 'div.indexed-sections-page-body' }
  trait(:page_url)     { '/indexed_sections_page.html' }
  trait(:navigator)    { header_nav.open_indexed_sections_page }

  def verify_page_ui
    ui = {
      self         => { exists: true, secure: false, title: 'Indexed Sections Page' },
      header_label => { visible: true, caption: 'Indexed Sections Page' }
    }
    verify_ui_states(ui)
  end
end
