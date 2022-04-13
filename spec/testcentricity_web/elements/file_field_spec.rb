# frozen_string_literal: true

describe TestCentricity::FileField, required: true do
  subject(:css_filefield) { described_class.new(:test_filefield, self, 'input#css_filefield', :page) }

  it 'returns class' do
    expect(css_filefield.class).to eql TestCentricity::FileField
  end

  it 'registers with type label' do
    expect(css_filefield.get_object_type).to eql :filefield
  end
end
