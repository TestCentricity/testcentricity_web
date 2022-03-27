# Page Object class definition for Base Test page

class BaseTestPage < TestCentricity::PageObject
  # Base Test page UI elements
  label    :header_label, 'h2'
  sections header_nav:    NavHeader

  def navigate_to
    navigator
  end
end
