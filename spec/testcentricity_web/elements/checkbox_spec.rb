# frozen_string_literal: true

describe TestCentricity::CheckBox, required: true do
  subject(:css_check) { described_class.new(:test_check, self, 'input#css_check', :page) }

  it 'returns class' do
    expect(css_check.class).to eql TestCentricity::CheckBox
  end

  it 'registers with type checkbox' do
    expect(css_check.get_object_type).to eql :checkbox
  end

  it 'should check the checkbox' do
    expect(css_check).to receive(:check)
    css_check.check
  end

  it 'should uncheck the checkbox' do
    expect(css_check).to receive(:uncheck)
    css_check.uncheck
  end

  it 'should know if checkbox is checked' do
    allow(css_check).to receive(:checked?).and_return(true)
    expect(css_check.checked?).to eq(true)
  end

  it 'should know if checkbox is indeterminate' do
    allow(css_check).to receive(:indeterminate?).and_return(true)
    expect(css_check.indeterminate?).to eq(true)
  end
end
