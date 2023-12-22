RSpec.shared_context 'test_site' do
  include_context 'cloud_credentials'

  let(:test_site_url) { 'https://www.apple.com' }
  let(:test_site_locator) { 'nav#globalnav' }
end
