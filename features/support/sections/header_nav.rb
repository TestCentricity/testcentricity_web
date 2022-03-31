# Section Object class definition for Top Navigation Bar

class NavHeader < TestCentricity::PageSection
  trait(:section_locator) { 'div#nav_bar' }
  trait(:section_name)    { 'Top Navigation Bar' }

  # Top Navigation Bar UI elements
  links form_link:             'a#form_link',
        media_link:            'a#media_link',
        indexed_sections_link: 'a#indexed_sections_link',
        custom_controls_link:  'a#custom_controls_link'

  def open_form_page
    form_link.click
  end

  def open_media_page
    media_link.click
  end

  def open_indexed_sections_page
    indexed_sections_link.click
  end

  def open_custom_controls_page
    custom_controls_link.click
  end

  def verify_nav_bar
    ui = {
      self => { exists: true, visible: true, class: 'topnav' },
      form_link => { visible: true, caption: 'Basic HTML Form' },
      media_link => { visible: true, caption: 'Media' },
      indexed_sections_link => { visible: true, caption: 'Indexed Sections' },
      custom_controls_link => { visible: true, caption: 'Custom Controls' },
    }
    verify_ui_states(ui)
  end
end
