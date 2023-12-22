# frozen_string_literal: true

RSpec.describe TestCentricity::Elements::Button, required: true do
  subject(:css_button) { described_class.new(:test_button, self, 'button#css_button', :page) }

  it 'returns class' do
    expect(css_button.class).to eql TestCentricity::Elements::Button
  end

  it 'registers with type button' do
    expect(css_button.get_object_type).to eql :button
  end

  it 'should click the button' do
    expect(css_button).to receive(:click)
    css_button.click
  end
end
