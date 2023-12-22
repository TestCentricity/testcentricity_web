# frozen_string_literal: true

RSpec.describe TestCentricity::Elements::FileField, required: true do
  subject(:css_filefield) { described_class.new(:test_filefield, self, 'input#css_filefield', :page) }

  it 'returns class' do
    expect(css_filefield.class).to eql TestCentricity::Elements::FileField
  end

  it 'registers with type label' do
    expect(css_filefield.get_object_type).to eql :filefield
  end
end
