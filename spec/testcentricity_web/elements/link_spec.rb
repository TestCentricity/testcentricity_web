# frozen_string_literal: true

describe TestCentricity::Link, required: true do
  subject(:css_link) { described_class.new(:test_label, self, 'a#css_label', :page) }

  it 'returns class' do
    expect(css_link.class).to eql TestCentricity::Link
  end

  it 'registers with type link' do
    expect(css_link.get_object_type).to eql :link
  end

  it 'returns href' do
    allow(css_link).to receive(:href).and_return('href')
    expect(css_link.href).to eql 'href'
  end

  it 'should click the link' do
    expect(css_link).to receive(:click)
    css_link.click
  end
end
