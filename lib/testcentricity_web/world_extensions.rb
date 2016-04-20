module WorldData
  def environs
    @environs ||= TestCentricity::EnvironData.new
  end

  # instantiate and register all data objects specified in data_objects method
  def instantiate_data_objects
    # return if data objects have already been instantiated and registered
    return if TestCentricity::DataManager.loaded?

    data_objects.each do | data_type, data_class |
      # instantiate next data object
      eval("def #{data_type.to_s};@#{data_type.to_s} ||= #{data_class}.new;end")
      # register the data object
      TestCentricity::DataManager.register_data_object(data_type, data_class.new)
    end
  end
end


module WorldPages
  # instantiate and register all page objects specified in page_objects method
  def instantiate_page_objects
    # return if page objects have already been instantiated and registered
    return if TestCentricity::PageManager.loaded?

    page_objects.each do | page_object, page_class |
      # instantiate next page object
      eval("def #{page_object.to_s};@#{page_object.to_s} ||= #{page_class}.new;end")
      # register the page object
      TestCentricity::PageManager.register_page_object(page_object, page_class.new)
    end
  end
end
