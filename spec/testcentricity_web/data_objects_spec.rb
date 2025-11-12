# frozen_string_literal: true

describe TestCentricity::DataObject, required: true do
  before(:each) do
    @pos_date_source = POSDataSource.new
    @geo_date_source = GeoLocationDataSource.new
  end

  context 'Read from DataSource object' do
    it 'raises exception when data source file does not exist' do
      expect { @pos_date_source.read('i_dont_exist.yml') }.to raise_error('File i_dont_exist.yml not found in Primary or Secondary folders in config folder')
    end

    it 'raises exception when data source file is not a supported file type' do
      expect { @pos_date_source.read('test_data.csv') }.to raise_error('test_data.csv is not a supported file type')
    end

    it 'reads all data from .yml data source file when no key and node are specified' do
      result = @pos_date_source.read('test_data.yml')
      expect(result).to eql(
                          { 'POS_Integrations' =>
                              {
                                'panera' =>
                                  {
                                    'sync_enabled' => false,
                                    'integration_id' => '11071',
                                    'location_id' => '204596',
                                    'max_sync_wait_time' => 30
                                  },
                                'seven_eleven' =>
                                  {
                                    'sync_enabled' => false,
                                    'integration_id' => '11061',
                                    'location_id' => '35702',
                                    'max_sync_wait_time' => 45
                                  },
                                'ordermark' =>
                                  {
                                    'sync_enabled' => true,
                                    'integration_id' => '10',
                                    'location_id' => '2f2e7884-86dc-489b-8de3-2f7adf0e99dc',
                                    'max_sync_wait_time' => 30
                                  }
                              },
                            'Geolocation_data' =>
                              {
                                'within_the_service_area' =>
                                  {
                                    'valid' => true,
                                    'in_service' => true,
                                    'address' => '2565 Kewanee Way, Minneapolis, MN 55422',
                                    'latitude' => '45.0057168',
                                    'longitude' => '-93.3315115'
                                  },
                                'outside_of_the_service_area' =>
                                  {
                                    'valid' => true,
                                    'in_service' => false,
                                    'address' => '82083 Bay Rd, Seaside, OR 97138',
                                    'latitude' => '45.8830449',
                                    'longitude' => '-123.5660093'
                                  }
                              }
                          }
                        )
    end

    it 'reads only key data from .yml data source file when key is specified but no node is specified' do
      result = @pos_date_source.read('test_data.yml', 'POS_Integrations')
      expect(result).to eql(
                          {
                            'panera' =>
                              {
                                'sync_enabled' => false,
                                'integration_id' => '11071',
                                'location_id' => '204596',
                                'max_sync_wait_time' => 30
                              },
                            'seven_eleven' =>
                              {
                                'sync_enabled' => false,
                                'integration_id' => '11061',
                                'location_id' => '35702',
                                'max_sync_wait_time' => 45
                              },
                            'ordermark' =>
                              {
                                'sync_enabled' => true,
                                'integration_id' => '10',
                                'location_id' => '2f2e7884-86dc-489b-8de3-2f7adf0e99dc',
                                'max_sync_wait_time' => 30
                              }
                          }
                        )
    end

    it 'reads only key/node data from .yml data source file when both key and node are specified' do
      result = @pos_date_source.read('test_data.yml', 'POS_Integrations', 'seven_eleven')
      expect(result).to eql(
                          {
                            'sync_enabled' => false,
                            'integration_id' => '11061',
                            'location_id' => '35702',
                            'max_sync_wait_time' => 45
                          }
                        )
    end

    it 'reads key/node data from .json data source file when both key and node are specified' do
      result = @geo_date_source.read('test_data.json', 'Geolocation_data', 'outside_of_the_service_area')
      expect(result).to eql(
                          {
                            'valid' => true,
                            'in_service' => false,
                            'address' => '82083 Bay Rd, Seaside, OR 97138',
                            'latitude' => '45.8830449',
                            'longitude' => '-123.5660093'
                          }
                        )
    end

    it 'reads key/node data from data source file located in secondary data sources folder' do
      result = @pos_date_source.read('aux_test_data.yml', 'POS_Integrations', 'ordermark')
      expect(result).to eql(
                          {
                            'sync_enabled' => true,
                            'integration_id' => '10',
                            'location_id' => '2f2e7884-86dc-489b-8de3-2f7adf0e99dc',
                            'max_sync_wait_time' => 30
                          }
                        )
    end
  end

  context 'Populate DataPresenter object with data from DataSource object' do
    it 'populates POS DataPresenter object with data for specific key and node' do
      @pos_date_source.find_pos_integration('ordermark')
      expect(POSData.current.sync_enabled).to eql(true)
      expect(POSData.current.integration_id).to eql('10')
      expect(POSData.current.location_id).to eql('2f2e7884-86dc-489b-8de3-2f7adf0e99dc')
      expect(POSData.current.max_sync_wait_time).to eql(30)
    end

    it 'populates GeoLocation DataPresenter object with data for specific key and node' do
      @geo_date_source.find_geolocation('within_the_service_area')
      expect(GeoLocation.current.in_service).to eql(true)
      expect(GeoLocation.current.valid).to eql(true)
      expect(GeoLocation.current.address).to eql('2565 Kewanee Way, Minneapolis, MN 55422')
      expect(GeoLocation.current.latitude).to eql('45.0057168')
      expect(GeoLocation.current.longitude).to eql('-93.3315115')
    end
  end
end
