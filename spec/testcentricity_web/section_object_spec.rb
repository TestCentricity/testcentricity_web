# frozen_string_literal: true

describe TestCentricity::PageSection, required: true do
  before :context do
    @test_page = TestPage.new
    @test_section = @test_page.section1
  end

  context 'section object traits' do
    it 'returns section name' do
      expect(@test_section.section_name).to eq('Basic Test Section')
    end

    it 'returns section locator' do
      expect(@test_section.get_locator).to eq('div#section')
    end

    it 'returns class' do
      expect(@test_section.class).to eql TestSection
    end

    it 'returns css locator type' do
      expect(@test_section.get_locator_type).to eql :css
    end

    it 'registers with type section' do
      expect(@test_section.get_object_type).to eql :section
    end

    it 'returns parent list object' do
      expect(@test_section.get_parent_list).to eql nil
    end
  end

  context 'section object with UI elements' do
    it 'responds to element' do
      expect(@test_section).to respond_to(:element1)
    end

    it 'responds to button' do
      expect(@test_section).to respond_to(:button1)
    end

    it 'responds to textfield' do
      expect(@test_section).to respond_to(:field1)
    end

    it 'responds to link' do
      expect(@test_section).to respond_to(:link1)
    end

    it 'responds to range' do
      expect(@test_section).to respond_to(:range1)
    end

    it 'responds to image' do
      expect(@test_section).to respond_to(:image1)
    end

    it 'responds to radio' do
      expect(@test_section).to respond_to(:radio1)
    end

    it 'responds to checkbox' do
      expect(@test_section).to respond_to(:check1)
    end

    it 'responds to section' do
      expect(@test_section).to respond_to(:section2)
    end
  end
end
