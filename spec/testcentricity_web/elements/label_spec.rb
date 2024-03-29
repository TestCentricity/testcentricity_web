# frozen_string_literal: true

RSpec.describe TestCentricity::Elements::Label, required: true do
  subject(:css_label) { described_class.new(:test_label, self, 'label#css_label', :page) }

  it 'returns class' do
    expect(css_label.class).to eql TestCentricity::Elements::Label
  end

  it 'registers with type label' do
    expect(css_label.get_object_type).to eql :label
  end

  it 'returns caption' do
    allow(css_label).to receive(:caption).and_return('caption')
    expect(css_label.caption).to eql 'caption'
  end
end
