# frozen_string_literal: true

describe TestCentricity::PageObject, required: true do
  before :context do
    @test_page = TestPage.new
  end

  context 'page object traits' do
    it 'returns page name' do
      expect(@test_page.page_name).to eq('Basic Test Page')
    end

    it 'returns page url' do
      expect(@test_page.page_url).to eq('/basic_test_page.html')
    end

    it 'returns page locator' do
      expect(@test_page.page_locator).to eq('form#HTMLFormElements')
    end

    it 'determines if page is secure' do
      allow(@test_page).to receive(:secure?).and_return(false)
      expect(@test_page.secure?).to eq(false)
    end

    it 'should display the title of the page' do
      allow(@test_page).to receive(:title).and_return('I am the title of a page')
      expect(@test_page.title).to eql 'I am the title of a page'
    end

    it 'determines if page is secure' do
      allow(@test_page).to receive(:secure?).and_return(false)
      expect(@test_page.secure?).to eq(false)
    end

    it 'responds to open_portal' do
      expect(@test_page).to respond_to(:open_portal)
    end

    it 'responds to load_page' do
      expect(@test_page).to respond_to(:load_page)
    end

    it 'responds to verify_page_exists' do
      expect(@test_page).to respond_to(:verify_page_exists)
    end

    it 'responds to exists?' do
      expect(@test_page).to respond_to(:exists?)
    end
  end

  context 'page object with UI elements' do
    it 'responds to element' do
      expect(@test_page).to respond_to(:element1)
    end

    it 'responds to button' do
      expect(@test_page).to respond_to(:button1)
    end

    it 'responds to textfield' do
      expect(@test_page).to respond_to(:field1)
    end

    it 'responds to link' do
      expect(@test_page).to respond_to(:link1)
    end

    it 'responds to range' do
      expect(@test_page).to respond_to(:range1)
    end

    it 'responds to image' do
      expect(@test_page).to respond_to(:image1)
    end

    it 'responds to radio' do
      expect(@test_page).to respond_to(:radio1)
    end

    it 'responds to checkbox' do
      expect(@test_page).to respond_to(:check1)
    end

    it 'responds to section' do
      expect(@test_page).to respond_to(:section1)
    end
  end
end
