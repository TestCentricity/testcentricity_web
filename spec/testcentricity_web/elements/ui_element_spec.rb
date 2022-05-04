# frozen_string_literal: true

describe TestCentricity::UIElement, required: true do
  subject(:css_element) { described_class.new(:css_test_element, self, 'button#css_button', :page) }
  subject(:xpath_element) { described_class.new(:xpath_test_element, self, "//button[@id='xpath_button']", :page) }

  it 'returns class' do
    expect(css_element.class).to eql described_class
  end

  it 'returns css locator type' do
    expect(css_element.get_locator_type).to eql :css
  end

  it 'returns xpath locator type' do
    expect(xpath_element.get_locator_type).to eql :xpath
  end

  it 'returns name' do
    expect(css_element.get_name).to eql :css_test_element
  end

  it 'returns locator' do
    expect(css_element.get_locator).to eql 'button#css_button'
  end

  it 'returns css locator type' do
    expect(css_element.get_locator_type).to eql :css
  end

  it 'should click the element' do
    allow(css_element).to receive(:click)
    css_element.click
  end

  it 'should double click the element' do
    allow(css_element).to receive(:double_click)
    css_element.double_click
  end

  it 'should right click the element' do
    allow(css_element).to receive(:right_click)
    css_element.right_click
  end

  it 'should click the element at specified offset' do
    allow(css_element).to receive(:click_at)
    css_element.click_at(10, 10)
  end

  it 'should hover over the element' do
    allow(css_element).to receive(:hover)
    css_element.hover
  end

  it 'should hover over the element at specified offset' do
    allow(css_element).to receive(:hover_at)
    css_element.hover_at(10, 15)
  end

  it 'should drag the element by specified offset' do
    allow(css_element).to receive(:drag_by)
    css_element.drag_by(20, 15)
  end

  it 'should know if element is visible' do
    allow(css_element).to receive(:visible?).and_return(false)
    expect(css_element.visible?).to eq(false)
  end

  it 'should know if element is hidden' do
    allow(css_element).to receive(:hidden?).and_return(true)
    expect(css_element.hidden?).to eq(true)
  end

  it 'should know if element exists' do
    allow(css_element).to receive(:exists?).and_return(true)
    expect(css_element.exists?).to be true
  end

  it 'should know if element is enabled' do
    allow(css_element).to receive(:enabled?).and_return(true)
    expect(css_element.enabled?).to eq(true)
  end

  it 'should know if element is disabled' do
    allow(css_element).to receive(:disabled?).and_return(true)
    expect(css_element.disabled?).to eq(true)
  end

  it 'should know if element is obscured' do
    allow(css_element).to receive(:obscured?).and_return(true)
    expect(css_element.obscured?).to eq(true)
  end

  it 'should know if element is focused' do
    allow(css_element).to receive(:focused?).and_return(true)
    expect(css_element.focused?).to eq(true)
  end

  it 'should know if element is displayed' do
    allow(css_element).to receive(:displayed?).and_return(true)
    expect(css_element.displayed?).to eq(true)
  end

  it 'should know if element is required' do
    allow(css_element).to receive(:required?).and_return(true)
    expect(css_element.required?).to eq(true)
  end

  it 'should send keys' do
    allow(css_element).to receive(:send_keys).with('foo bar')
    css_element.send_keys('foo bar')
  end

  it 'should right highlight the element' do
    allow(css_element).to receive(:highlight)
    css_element.highlight(2)
  end

  it 'should right unhighlight the element' do
    allow(css_element).to receive(:unhighlight)
    css_element.unhighlight
  end
end
