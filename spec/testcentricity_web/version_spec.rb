# frozen_string_literal: true

RSpec.describe 'TestCentricityWeb::VERSION', required: true do
  subject { TestCentricityWeb::VERSION }

  it { is_expected.to be_truthy }
end