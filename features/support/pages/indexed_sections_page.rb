# Page Object class definition for Indexed Sections page with CSS locators

class IndexedSectionsPage < BaseTestPage
  trait(:page_name)    { 'Indexed Sections' }
  trait(:page_locator) { 'div.indexed-sections-page-body' }
  trait(:page_url)     { '/indexed_sections_page.html' }
  trait(:navigator)    { header_nav.open_indexed_sections_page }
  trait(:page_title)   { 'Indexed Sections Page'}

  def verify_page_ui
    super
  end
end
