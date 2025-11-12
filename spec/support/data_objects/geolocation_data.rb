# GeoLocation data sourcing object
class GeoLocationDataSource < TestCentricity::DataSource
  # read geolocation data from Geolocation_data section of test_data file and populate the GeoLocation data presenter object
  def find_geolocation(location_name)
    GeoLocation.current = GeoLocation.new(read('test_data.yml', 'Geolocation_data', location_name))
  end
end


# GeoLocation data presenter object
class GeoLocation < TestCentricity::DataPresenter
  attribute :valid, Boolean, default: false
  attribute :in_service, Boolean, default: false
  attribute :address, String
  attribute :latitude, String
  attribute :longitude, String
end
