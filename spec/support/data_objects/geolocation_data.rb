# GeoLocation data sourcing object
class GeoLocationDataSource < TestCentricity::DataSource
  # read geolocation data from Geolocation_data section of test_data file and populate the GeoLocation data presenter object
  def find_geolocation(location_name, options)
    GeoLocation.current = GeoLocation.new(read_file('test_data.yml', 'Geolocation_data', location_name, options))
  end
end


# GeoLocation data presenter object
class GeoLocation < TestCentricity::DataPresenter
  attribute :valid, Boolean, default: false
  attribute :in_service, Boolean, default: false
  attribute :address, String
  attribute :latitude, Float
  attribute :longitude, Float
  attribute :int_val, Integer
  attribute :float_val, Float
end
