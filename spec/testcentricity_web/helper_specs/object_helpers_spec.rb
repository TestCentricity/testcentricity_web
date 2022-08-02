# frozen_string_literal: true

RSpec.describe Object, required: true do
  it 'returns true when blank' do
    [nil, {}, ''].each do |value|
      expect(value.blank?).to eql true
    end
  end

  it 'returns false when not blank' do
    [0, 42, 'fred', ['Fred', 21], {a: 42}].each do |value|
      expect(value.blank?).to eql false
    end
  end

  it 'returns true when present' do
    [0, 42, 'fred', ['Fred', 21], {a: 42}].each do |value|
      expect(value.present?).to eql true
    end
  end

  it 'returns false when not present' do
    [nil, {}, ''].each do |value|
      expect(value.present?).to eql false
    end
  end

  it 'returns true when Boolean' do
    [!nil?, nil?, 2 + 2 == 4].each do |value|
      expect(value.boolean?).to eql true
    end
  end

  it 'returns false when not a Boolean' do
    [4, 'Ethel', [1, 'a']].each do |value|
      expect(value.boolean?).to eql false
    end
  end
end
