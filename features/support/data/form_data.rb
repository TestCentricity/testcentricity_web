class FormDataSource < TestCentricity::DataSource
  def read_form_data
    FormData.current = FormData.new(environs.read('Form_data', 'primary'))
  end

  def map_form_data(form_data)
    FormData.current = FormData.new(form_data)
  end
end


class FormData < TestCentricity::DataPresenter
  attribute :username, String
  attribute :password, String
  attribute :image_filename, String
  attribute :multi_select, String
  attribute :drop_down_item, String
  attribute :check1, Boolean, default: false
  attribute :check2, Boolean, default: false
  attribute :check3, Boolean, default: false
  attribute :radio_select, Integer

  def initialize(data)
    @username       = data[:username]
    @password       = data[:password]
    @image_filename = data[:image_filename]
    @multi_select   = data[:multi_select]
    @drop_down_item = data[:drop_down_item]
    @check1         = data[:check1]
    @check2         = data[:check2]
    @check3         = data[:check3]
    @radio_select   = data[:radio_select]
    super
  end
end
