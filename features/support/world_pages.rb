module WorldPages
  #
  #  page_objects method returns a hash table of your web app's page objects and associated page classes to be instantiated
  # by the TestCentricity™ PageManager. Page Object class definitions are contained in the features/support/pages folder.
  #
  def page_objects
    {
      basic_css_form_page:   BasicCSSFormPage,
      basic_xpath_form_page: BasicXpathFormPage,
      media_test_page:       MediaTestPage,
      indexed_sections_page: IndexedSectionsPage,
      custom_controls_page:  CustomControlsPage
    }
  end
end


World(WorldPages)
