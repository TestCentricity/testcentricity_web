RSpec.shared_context 'cloud_credentials' do
  def load_cloud_credentials
    @cloud_creds ||= YAML.load_file('/Users/Shared/config/env.yml')
    @cloud_creds = @cloud_creds['cloud_creds']
    # load BrowserStack credentials into associated environment variables
    ENV['BS_USERNAME'] = @cloud_creds['browserstack']['BS_USERNAME']
    ENV['BS_AUTHKEY'] = @cloud_creds['browserstack']['BS_AUTHKEY']
    # load Sauce Labs credentials into associated environment variables
    ENV['SL_USERNAME'] = @cloud_creds['saucelabs']['SL_USERNAME']
    ENV['SL_AUTHKEY'] = @cloud_creds['saucelabs']['SL_AUTHKEY']
    # load TestingBot credentials into associated environment variables
    ENV['TB_USERNAME'] = @cloud_creds['testingbot']['TB_USERNAME']
    ENV['TB_AUTHKEY'] = @cloud_creds['testingbot']['TB_AUTHKEY']
  end
end
