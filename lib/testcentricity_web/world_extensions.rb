module WorldData
  def environs
    @environs ||= TestCentricity::EnvironData
  end

  # instantiate and register all data objects specified in data_objects method
  def instantiate_data_objects
    # return if data objects have already been instantiated and registered
    return if TestCentricity::DataManager.loaded?

    # instantiate all data objects
    @data = {}
    data_objects.each do |data_type, data_class|
      @data[data_type] = data_class.new unless @data.has_key?(data_type)
      # define data object accessor method
      define_method(data_type) do
        if instance_variable_defined?(:"@#{data_type}")
          instance_variable_get(:"@#{data_type}")
        else
          instance_variable_set(:"@#{data_type}", TestCentricity::DataManager.find_data_object(data_type))
        end
      end
    end
    # register all data objects with DataManager
    TestCentricity::DataManager.register_data_objects(@data)
  end
end


module WorldPages
  # instantiate and register all page objects specified in page_objects method
  def instantiate_page_objects
    # return if page objects have already been instantiated and registered
    return if TestCentricity::PageManager.loaded?

    # instantiate all page objects
    @pages = {}
    page_objects.each do |page_object, page_class|
      obj = page_class.new
      @pages[page_object] = obj unless @pages.has_key?(page_object)
      page_names = obj.page_name
      page_names = Array(page_names) if page_names.is_a? String
      page_names.each do |name|
        page_key = name.gsub(/\s+/, '').downcase.to_sym
        @pages[page_key] = obj unless @pages.has_key?(page_key)
      end
      # define page object accessor method
      define_method(page_object) do
        if instance_variable_defined?(:"@#{page_object}")
          instance_variable_get(:"@#{page_object}")
        else
          instance_variable_set(:"@#{page_object}", TestCentricity::PageManager.find_page(page_object))
        end
      end
    end
    # register all page objects with PageManager
    TestCentricity::PageManager.register_page_objects(@pages)
  end
end
