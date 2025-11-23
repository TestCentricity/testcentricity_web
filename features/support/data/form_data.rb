class FormDataSource < TestCentricity::DataSource
  def read_form_data
    options = {
      keys_as_symbols: true,
      value_converters:
        {
          number_int: ToInteger,
          number_flt: ToFloat
        }
    }
    FormData.current = FormData.new(environs.read('Form_data', 'primary', options))
    FormData.current.attributes
  end

  def map_form_data(form_data)
    FormData.current = FormData.new(form_data)
  end
end


class FormData < TestCentricity::DataPresenter
  attribute :username, String
  attribute :password, String
  attribute :max_length, String
  attribute :number_int, Integer
  attribute :number_flt, Float
  attribute :color, String
  attribute :slider, Integer, default: 50
  attribute :comments, String
  attribute :image_file, String
  attribute :file_name, String
  attribute :multi_select, String
  attribute :drop_select, String
  attribute :check_1, Boolean, default: false
  attribute :check_2, Boolean, default: false
  attribute :check_3, Boolean, default: false
  attribute :radio_select, Integer
  attribute :formatted_date, String
  attribute :days_past, String

  def initialize(data)
    super

    @comments = "#{@formatted_date} - #{@comments} - #{@days_past}"

    if Environ.platform == :mobile
      @image_file = nil
      @file_name = ''
      @color = '#000000'
    else
      @file_name = @image_file
      @image_file = "#{Dir.pwd}/test_site/images/#{@image_file}"
      @color = Faker::Color.hex_color
    end
  end
end
