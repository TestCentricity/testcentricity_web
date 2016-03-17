module WorldData
  def environs
    @environs ||= TestCentricity::EnvironData.new
  end

  def instantiate_data_objects
    return if TestCentricity::DataManager.loaded?

    data_objects.each do | data_type, data_class |
      eval("def #{data_type.to_s};@#{data_type.to_s} ||= #{data_class}.new;end")
      TestCentricity::DataManager.register_data_object(data_type, data_class.new)
    end
  end
end


module WorldPages
  def instantiate_page_objects
    return if TestCentricity::PageManager.loaded?

    page_objects.each do | page_object, page_class |
      eval("def #{page_object.to_s};@#{page_object.to_s} ||= #{page_class}.new;end")
      TestCentricity::PageManager.register_page_object(page_object, page_class.new)
    end
  end
end
