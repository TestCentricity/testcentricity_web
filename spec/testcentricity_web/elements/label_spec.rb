# frozen_string_literal: true

describe TestCentricity::Label, required: true do
  subject(:css_label) { described_class.new(:test_label, self, 'label#css_label', :page) }

  it 'returns class' do
    expect(css_label.class).to eql TestCentricity::Label
  end

  it 'registers with type label' do
    expect(css_label.get_object_type).to eql :label
  end
end
