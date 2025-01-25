RSpec.shared_context 'cloud_credentials' do
  def load_cloud_credentials
    data ||= YAML.load_file('/Users/Shared/config/env.yml')
    @cloud_creds = data['cloud_creds']
    # load BrowserStack credentials into associated environment variables
    ENV['BS_USERNAME'] = @cloud_creds['browserstack']['BS_USERNAME']
    ENV['BS_AUTHKEY'] = @cloud_creds['browserstack']['BS_AUTHKEY']
    # load Sauce Labs credentials into associated environment variables
    ENV['SL_USERNAME'] = @cloud_creds['saucelabs']['SL_USERNAME']
    ENV['SL_AUTHKEY'] = @cloud_creds['saucelabs']['SL_AUTHKEY']
    ENV['SL_DATA_CENTER'] = @cloud_creds['saucelabs']['SL_DATA_CENTER']
    # load TestingBot credentials into associated environment variables
    ENV['TB_USERNAME'] = @cloud_creds['testingbot']['TB_USERNAME']
    ENV['TB_AUTHKEY'] = @cloud_creds['testingbot']['TB_AUTHKEY']
    # load LambdaTest credentials into associated environment variables
    ENV['LT_USERNAME'] = @cloud_creds['lambdatest']['LT_USERNAME']
    ENV['LT_AUTHKEY'] = @cloud_creds['lambdatest']['LT_AUTHKEY']
    # load the locally hosted test web site base URL
    ENV['BASE_URL'] = data['test_site']['base_url']
  end
end
