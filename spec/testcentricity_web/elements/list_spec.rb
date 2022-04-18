# frozen_string_literal: true

describe TestCentricity::List, required: true do
  subject(:css_list) { described_class.new(:test_list, self, 'ul#css_list', :page) }

  it 'returns class' do
    expect(css_list.class).to eql TestCentricity::List
  end

  it 'registers with type list' do
    expect(css_list.get_object_type).to eql :list
  end
end
