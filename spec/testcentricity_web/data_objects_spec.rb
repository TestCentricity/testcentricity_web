# frozen_string_literal: true

describe TestCentricity::DataSource, required: true do
  before(:context) do
    @pos_date_source = POSDataSource.new
    @geo_date_source = GeoLocationDataSource.new
  end

  context 'DataSource exceptions' do
    it 'raises exception when data source file does not exist' do
      expect { @pos_date_source.read_file('i_dont_exist.yml') }.to raise_error('File i_dont_exist.yml not found in Primary or Secondary folders in config folder')
    end

    it 'raises exception when data source file is not a supported file type' do
      expect { @pos_date_source.read_file('test_data.txt') }.to raise_error('test_data.txt is not a supported file type')
    end

    it 'raises exception when specified key is sis not found' do
      expect { @pos_date_source.read_file('test_data.yml', 'invalid_key') }.to raise_error('Key invalid_key not found')
    end

    it 'raises exception when specified node is sis not found' do
      expect { @pos_date_source.read_file('test_data.yml', 'POS_Integrations', 'invalid_node') }.to raise_error('Node invalid_node not found')
    end
  end

  context 'Read from .yml DataSource object' do
    it 'reads all data from .yml data source file when no key and node are specified' do
      result = @pos_date_source.read_file('test_data.yml')
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
                                    'longitude' => '-93.3315115',
                                    'float_val' => 'eval!Number.between(from: 1.25, to: 9.75)',
                                    'int_val' => 'eval!Number.between(from: 1, to: 200)'
                                  },
                                'outside_of_the_service_area' =>
                                  {
                                    'valid' => true,
                                    'in_service' => false,
                                    'address' => '82083 Bay Rd, Seaside, OR 97138',
                                    'latitude' => '45.8830449',
                                    'longitude' => '-123.5660093',
                                    'float_val' => 'eval!Number.between(from: 1.25, to: 9.75)',
                                    'int_val' => 'eval!Number.between(from: 1, to: 200)'
                                  }
                              }
                          }
                        )
    end

    it 'reads only key data from .yml data source file when key is specified but no node is specified' do
      result = @pos_date_source.read_file('test_data.yml', 'POS_Integrations')
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
      result = @pos_date_source.read_file('test_data.yml', 'POS_Integrations', 'seven_eleven')
      expect(result).to eql(
                          {
                            'sync_enabled' => false,
                            'integration_id' => '11061',
                            'location_id' => '35702',
                            'max_sync_wait_time' => 45
                          }
                        )
    end

    it 'reads key/node data from data source file located in secondary data sources folder' do
      result = @pos_date_source.read_file('aux_test_data.yml', 'POS_Integrations', 'ordermark')
      expect(result).to eql(
                          {
                            'sync_enabled' => true,
                            'integration_id' => '10',
                            'location_id' => '2f2e7884-86dc-489b-8de3-2f7adf0e99dc',
                            'max_sync_wait_time' => 30
                          }
                        )
    end

    it 'reads key/node data from data source file where full file path is specified' do
      result = @pos_date_source.read_file('features/support/data/alt_test_data.yml', 'POS_Integrations', 'panera')
      expect(result).to eql(
                          {
                            'sync_enabled' => false,
                            'integration_id' => '11071',
                            'location_id' => '204596',
                            'max_sync_wait_time' => 30
                          }
                        )
    end
  end

  context 'Read from .json DataSource object' do
    it 'reads all data from .json data source file when no key and node are specified' do
      result = @pos_date_source.read_file('test_data.json')
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
                                    'longitude' => '-93.3315115',
                                    'float_val' => 'eval!Number.between(from: 1.25, to: 9.75)',
                                    'int_val' => 'eval!Number.between(from: 1, to: 200)'
                                  },
                                'outside_of_the_service_area' =>
                                  {
                                    'valid' => true,
                                    'in_service' => false,
                                    'address' => '82083 Bay Rd, Seaside, OR 97138',
                                    'latitude' => '45.8830449',
                                    'longitude' => '-123.5660093',
                                    'float_val' => 'eval!Number.between(from: 1.25, to: 9.75)',
                                    'int_val' => 'eval!Number.between(from: 1, to: 200)'
                                  }
                              }
                          }
                        )
    end

    it 'reads only key data from .json data source file when key is specified but no node is specified' do
      result = @pos_date_source.read_file('test_data.json', 'POS_Integrations')
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

    it 'reads only key/node data from .json data source file when both key and node are specified' do
      result = @pos_date_source.read_file('test_data.json', 'POS_Integrations', 'ordermark')
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

  context 'Read from .csv DataSource object' do
    it 'reads all data from .csv data source file with no options' do
      result = @pos_date_source.read_file('test_data.csv')
      expect(result).to eql(
                          [
                            {
                              id: 'panera',
                              integration_id: 11071,
                              location_id: 204596,
                              max_sync_wait_time: 30,
                              sync_enabled: 'false'
                            },
                            {
                              id: 'seven_eleven',
                              integration_id: 11061,
                              location_id: 35702,
                              max_sync_wait_time: 45,
                              sync_enabled: 'false'
                            },
                            {
                              id: 'ordermark',
                              integration_id: 10,
                              location_id: '2f2e7884-86dc-489b-8de3-2f7adf0e99dc',
                              max_sync_wait_time: 30,
                              sync_enabled: 'true'
                            }
                          ]
                        )
    end
  end

  context 'Read from .xml DataSource object' do
    it 'reads all data from .xml data source file with no options' do
      result = @pos_date_source.read_file('test_data.xml')
      expect(result).to eql(
                          { 'POS_Integrations' =>
                              {
                                'panera' =>
                                  {
                                    'sync_enabled' => 'false',
                                    'integration_id' => '11071',
                                    'location_id' => '204596',
                                    'max_sync_wait_time' => '30'
                                  },
                                'seven_eleven' =>
                                  {
                                    'sync_enabled' => 'false',
                                    'integration_id' => '11061',
                                    'location_id' => '35702',
                                    'max_sync_wait_time' => '45'
                                  },
                                'ordermark' =>
                                  {
                                    'sync_enabled' => 'true',
                                    'integration_id' => '10',
                                    'location_id' => '2f2e7884-86dc-489b-8de3-2f7adf0e99dc',
                                    'max_sync_wait_time' => '30'
                                  }
                              }
                          }
                        )
    end

    it 'reads only key data from .xml data source file when key is specified but no node is specified' do
      result = @pos_date_source.read_file('test_data.xml', 'POS_Integrations')
      expect(result).to eql(
                          {
                            'panera' =>
                              {
                                'sync_enabled' => 'false',
                                'integration_id' => '11071',
                                'location_id' => '204596',
                                'max_sync_wait_time' => '30'
                              },
                            'seven_eleven' =>
                              {
                                'sync_enabled' => 'false',
                                'integration_id' => '11061',
                                'location_id' => '35702',
                                'max_sync_wait_time' => '45'
                              },
                            'ordermark' =>
                              {
                                'sync_enabled' => 'true',
                                'integration_id' => '10',
                                'location_id' => '2f2e7884-86dc-489b-8de3-2f7adf0e99dc',
                                'max_sync_wait_time' => '30'
                              }
                          }
                        )
    end

    it 'reads only key/node data from .xml data source file when both key and node are specified' do
      result = @pos_date_source.read_file('test_data.xml', 'POS_Integrations', 'seven_eleven')
      expect(result).to eql(
                          {
                            'sync_enabled' => 'false',
                            'integration_id' => '11061',
                            'location_id' => '35702',
                            'max_sync_wait_time' => '45'
                          }
                        )
    end
  end

  context 'Read from DataSource object with conversion options' do
    it 'reads key/node data from .yml data source file with hash key conversion option' do
      options = { keys_as_symbols: true }
      result = @pos_date_source.read_file('test_data.yml', 'POS_Integrations', 'seven_eleven', options)
      expect(result).to eql(
                          {
                            sync_enabled: false,
                            integration_id: '11061',
                            location_id: '35702',
                            max_sync_wait_time: 45
                          }
                        )
    end

    it 'reads key/node data from .json data source file with hash key conversion option' do
      options = { keys_as_symbols: true }
      result = @pos_date_source.read_file('test_data.json', 'POS_Integrations', 'ordermark', options)
      expect(result).to eql(
                          {
                            sync_enabled: true,
                            integration_id: '10',
                            location_id: '2f2e7884-86dc-489b-8de3-2f7adf0e99dc',
                            max_sync_wait_time: 30
                          }
                        )
    end

    it 'reads all data from .csv data source file with header conversion options' do
      options = { strings_as_keys: true }
      result = @pos_date_source.read_file('test_data.csv', nil, nil, options)
      expect(result).to eql(
                          [
                            {
                              'id' => 'panera',
                              'integration_id' => 11071,
                              'location_id' => 204596,
                              'max_sync_wait_time' => 30,
                              'sync_enabled' => 'false'
                            },
                            {
                              'id' => 'seven_eleven',
                              'integration_id' => 11061,
                              'location_id' => 35702,
                              'max_sync_wait_time' => 45,
                              'sync_enabled' => 'false'
                            },
                            {
                              'id' => 'ordermark',
                              'integration_id' => 10,
                              'location_id' => '2f2e7884-86dc-489b-8de3-2f7adf0e99dc',
                              'max_sync_wait_time' => 30,
                              'sync_enabled' => 'true'
                            }
                          ]
                        )
    end

    it 'reads all data from .csv data source file with String and Boolean conversion options' do
      options = {
        value_converters:
          {
            integration_id: ToString,
            location_id: ToString,
            sync_enabled: ToBoolean
          }
      }
      result = @pos_date_source.read_file('test_data.csv', nil, nil, options)
      expect(result).to eql(
                          [
                            {
                              id: 'panera',
                              integration_id: '11071',
                              location_id: '204596',
                              max_sync_wait_time: 30,
                              sync_enabled: false
                            },
                            {
                              id: 'seven_eleven',
                              integration_id: '11061',
                              location_id: '35702',
                              max_sync_wait_time: 45,
                              sync_enabled: false
                            },
                            {
                              id: 'ordermark',
                              integration_id: '10',
                              location_id: '2f2e7884-86dc-489b-8de3-2f7adf0e99dc',
                              max_sync_wait_time: 30,
                              sync_enabled: true
                            }
                          ]
                        )
    end

    it 'reads key/node data from .xml data source file with Integer and Boolean conversion options' do
      options = {
        keys_as_symbols: true,
        value_converters:
          {
            sync_enabled: ToBoolean,
            max_sync_wait_time: ToInteger
          }
      }
      result = @pos_date_source.read_file('test_data.xml', 'POS_Integrations', 'seven_eleven', options)
      expect(result).to eql(
                          {
                            sync_enabled: false,
                            integration_id: '11061',
                            location_id: '35702',
                            max_sync_wait_time: 45
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

    it 'populates GeoLocation DataPresenter object with key/node data and Float conversion options' do
      options = {
        keys_as_symbols: true,
        value_converters:
          {
            latitude: ToFloat,
            longitude: ToFloat
          }
      }
      @geo_date_source.find_geolocation('within_the_service_area', options)
      expect(GeoLocation.current.in_service).to eql(true)
      expect(GeoLocation.current.valid).to eql(true)
      expect(GeoLocation.current.address).to eql('2565 Kewanee Way, Minneapolis, MN 55422')
      expect(GeoLocation.current.latitude).to eql(45.0057168)
      expect(GeoLocation.current.longitude).to eql(-93.3315115)
    end
  end
end
