# frozen_string_literal: true

describe TestCentricity::AppiumServer, required: true do
  before(:context) do
    $server = TestCentricity::AppiumServer.new
  end

  before(:each) do
    $server.start
  end

  context 'Appium Server' do
    it 'verifies server can be started' do
      expect($server.running?).to eq(true)
    end

    it 'verifies server can be restarted' do
      $server.start
      expect($server.running?).to eq(true)
    end

    it 'verifies server can be stopped' do
      $server.stop
      expect($server.running?).to eq(false)
    end
  end

  after(:each) do
    $server.stop if $server.running?
  end
end
