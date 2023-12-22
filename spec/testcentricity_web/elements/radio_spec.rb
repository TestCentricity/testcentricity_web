# frozen_string_literal: true

RSpec.describe TestCentricity::Elements::Radio, required: true do
  subject(:css_radio) { described_class.new(:test_radio, self, 'input#css_radio', :page) }

  it 'returns class' do
    expect(css_radio.class).to eql TestCentricity::Elements::Radio
  end

  it 'registers with type radio' do
    expect(css_radio.get_object_type).to eql :radio
  end

  it 'should select the radio' do
    expect(css_radio).to receive(:select)
    css_radio.select
  end

  it 'should unselect the radio' do
    expect(css_radio).to receive(:unselect)
    css_radio.unselect
  end

  it 'should know if radio is selected' do
    allow(css_radio).to receive(:selected?).and_return(true)
    expect(css_radio.selected?).to eq(true)
  end
end
