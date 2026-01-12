# POS data sourcing object
class POSDataSource < TestCentricity::DataSource
  # read POS Integration data from POS_Integrations section of test_data file and populate the POS data presenter object
  def find_pos_integration(pos_integration_name)
    POSData.current = POSData.new(read_file('test_data.yml', 'POS_Integrations', pos_integration_name))
  end
end


# POS data presenter object
class POSData < TestCentricity::DataPresenter
  attribute :sync_enabled, Boolean, default: false
  attribute :integration_id, String
  attribute :location_id, String
  attribute :max_sync_wait_time, Integer
end
