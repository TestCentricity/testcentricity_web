# frozen_string_literal: true

RSpec.describe TestCentricity::Elements::Image, required: true do
  subject(:css_image) { described_class.new(:test_image, self, 'img#css_image', :page) }

  it 'returns class' do
    expect(css_image.class).to eql TestCentricity::Elements::Image
  end

  it 'registers with type image' do
    expect(css_image.get_object_type).to eql :image
  end

  it 'returns loaded' do
    allow(css_image).to receive(:loaded?).and_return(true)
    expect(css_image.loaded?).to eql true
  end

  it 'returns broken' do
    allow(css_image).to receive(:broken?).and_return(false)
    expect(css_image.broken?).to eql false
  end

  it 'returns alt' do
    allow(css_image).to receive(:alt).and_return('alt')
    expect(css_image.alt).to eql 'alt'
  end

  it 'returns src' do
    allow(css_image).to receive(:src).and_return('src')
    expect(css_image.src).to eql 'src'
  end
end
