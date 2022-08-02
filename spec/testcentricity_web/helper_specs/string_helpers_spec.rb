# frozen_string_literal: true

RSpec.describe String, required: true do
  it 'returns string between' do
    expect('The rain in Spain'.string_between('The ', ' Spain')).to eql 'rain in'
  end

  it 'returns title case' do
    expect('The rain in Spain'.titlecase).to eql 'The Rain In Spain'
  end

  it 'returns boolean value when true' do
    %w[true t yes y x 1].each do |value|
      expect(value.to_bool).to eql true
    end
  end

  it 'returns boolean value when false' do
    %w[false f no n 0].each do |value|
      expect(value.to_bool).to eql false
    end
  end

  it 'returns true when Integer' do
    %w[26 3 10345].each do |value|
      expect(value.is_int?).to eql true
    end
  end

  it 'returns false when not an Integer' do
    %w[271.234 0.1234 Fred].each do |value|
      expect(value.is_int?).to eql false
    end
  end

  it 'returns true when Float' do
    %w[271.234 0.1234 21.4].each do |value|
      expect(value.is_float?).to eql true
    end
  end

  it 'returns formatted date' do
    expect('04/06/2022'.format_date_time('%A, %d %b %Y')).to eql 'Saturday, 04 Jun 2022'
  end

  it 'returns translated formatted date' do
    expect('04/06/2022'.format_date_time(:abbrev)).to eql 'Jun 04, 2022'
  end
end
