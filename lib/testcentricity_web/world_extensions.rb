module WorldData
  def environs
    @environs ||= TestCentricity::EnvironData.new
  end

  # instantiate and register all data objects specified in data_objects method
  def instantiate_data_objects
    # return if data objects have already been instantiated and registered
    return if TestCentricity::DataManager.loaded?

    # register and instantiate all data objects
    eval(TestCentricity::DataManager.register_data_objects(data_objects))
  end
end


module WorldPages
  # instantiate and register all page objects specified in page_objects method
  def instantiate_page_objects
    # return if page objects have already been instantiated and registered
    return if TestCentricity::PageManager.loaded?

    # register and instantiate all page objects
    eval(TestCentricity::PageManager.register_page_objects(page_objects))
  end
end
