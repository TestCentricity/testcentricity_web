
def run_first_once
  # HTML report header information if reporting is enabled
  log Environ.report_header if ENV['REPORTING']
end


BeforeAll do
  # start Appium Server if command line option was specified and target browser is mobile simulator or device
  if ENV['APPIUM_SERVER'] == 'run' && Environ.driver == :appium
    $server = TestCentricity::AppiumServer.new
    $server.start
  end
end


AfterAll do
  # close driver
  terminate_session
  # terminate Appium Server if command line option was specified and target browser is mobile simulator or device
  if ENV['APPIUM_SERVER'] == 'run' && Environ.driver == :appium && $server.running?
    $server.stop
  end
end


Before do |scenario|
  # if executing tests in parallel concurrent threads, print thread number with scenario name
  message = Environ.parallel ? "Thread ##{Environ.process_num} | Scenario:  #{scenario.name}" : "Scenario:  #{scenario.name}"
  log message
  $initialized ||= false
  unless $initialized
    $initialized = true
    $test_start_time = Time.now
    # if a run first/run once method is defined, call it
    run_first_once if defined? run_first_once
  end
end


After do |scenario|
  # process and embed any screenshots recorded during execution of scenario
  process_embed_screenshots(scenario)
  # clear out any queued screenshots
  Environ.reset_contexts
  # close any external pages that may have been opened
  if Environ.external_page
    Browsers.close_current_browser_instance
    begin
      page.driver.browser.switch_to.alert.accept
      Browsers.switch_to_new_browser_instance
    rescue
    end
    Environ.set_external_page(false)
  end
  # block any JavaScript modals that may appear as a result of ending the session
  Browsers.suppress_js_leave_page_modal
  # close Capybara Appium driver if it was opened
  Capybara.page.driver.quit if Capybara.default_driver == :appium

  if ENV['QUIT_DRIVER']
    terminate_session
  elsif Environ.grid == :browserstack
    # restart BrowserStack test sessions if test duration exceeds 110 minutes to avoid the 2 hour test limit
    test_elapsed_time = Time.now - $test_start_time
    if test_elapsed_time > 6600
      terminate_session
      log 'Restarting BrowserStack test session'
      $test_start_time = Time.now
    else
      Capybara.reset_sessions!
    end
  end
end


# exclusionary Around hooks to prevent running feature/scenario on unsupported browsers, devices, or
# cloud remote browser hosting platforms. Use the following tags to block test execution:
#   desktop web browsers:      @!safari, @!ie, @!firefox, @!chrome, @!edge
#   mobile devices:            @!ipad, @!iphone
#   remotely hosted browsers:  @!browserstack, @!saucelabs

# block feature/scenario execution if running against Safari browser
Around('@!safari') do |scenario, block|
  qualify_browser(:safari, 'Safari', scenario, block)
end


# block feature/scenario execution if running against Internet Explorer browser
Around('@!ie') do |scenario, block|
  qualify_browser(:ie, 'Internet Explorer', scenario, block)
end


# block feature/scenario execution if running against Microsoft Edge browser
Around('@!edge') do |scenario, block|
  qualify_browser(:edge, 'Edge', scenario, block)
end


# block feature/scenario execution if running against Chrome browser
Around('@!chrome') do |scenario, block|
  qualify_browser(:chrome, 'Chrome', scenario, block)
end


# block feature/scenario execution if running against Firefox browser
Around('@!firefox') do |scenario, block|
  qualify_browser(:firefox, 'Firefox', scenario, block)
end


Around('@!firefox_headless') do |scenario, block|
  qualify_browser(:firefox_headless, 'Firefox headless', scenario, block)
end


# block feature/scenario execution if running against iPad mobile browser
Around('@!ipad') do |scenario, block|
  qualify_device('ipad', scenario, block)
end


# block feature/scenario execution if running against iPhone mobile browser
Around('@!iphone') do |scenario, block|
  qualify_device('iphone', scenario, block)
end


# block feature/scenario execution if running on Selenium Grid or cloud-hosted services
Around('@!grid') do |scenario, block|
  if !Environ.grid
    block.call
  else
    log "Scenario '#{scenario.name}' cannot be executed on Selenium Grid or cloud-hosted services."
    skip_this_scenario
  end
end


# block feature/scenario execution if running against Browserstack cloud-hosted service
Around('@!browserstack') do |scenario, block|
  if Environ.grid != :browserstack
    block.call
  else
    log "Scenario '#{scenario.name}' cannot be executed on the BrowserStack service."
    skip_this_scenario
  end
end


# block feature/scenario execution if running against Sauce Labs cloud-hosted service
Around('@!saucelabs') do |scenario, block|
  if Environ.grid != :saucelabs
    block.call
  else
    log "Scenario '#{scenario.name}' cannot be executed on the SauceLabs service."
    skip_this_scenario
  end
end


# block feature/scenario execution if running against a physical or emulated mobile device
Around('@!device') do |scenario, block|
  if Environ.is_device?
    log "Scenario '#{scenario.name}' cannot be executed on physical or emulated devices."
    skip_this_scenario
  else
    block.call
  end
end


Around('@!ios') do |scenario, block|
  if Environ.device_os == :android
    block.call
  else
    log "Scenario '#{scenario.name}' can not be executed on iOS devices."
    skip_this_scenario
  end
end


Around('@!android') do |scenario, block|
  if Environ.device_os == :ios
    block.call
  else
    log "Scenario '#{scenario.name}' can not be executed on Android devices."
    skip_this_scenario
  end
end


Around('@!mobile') do |scenario, block|
  if Environ.platform == :mobile
    log "Scenario '#{scenario.name}' is not executed on mobile devices or simulators."
    skip_this_scenario
  else
    block.call
  end
end


Around('@!headless') do |scenario, block|
  if Environ.headless
    log "Scenario '#{scenario.name}' is not executed on headless browsers."
    skip_this_scenario
  else
    block.call
  end
end


Around('@!firefox_grid') do |scenario, block|
  if Environ.browser == :firefox && Environ.grid
    log "Scenario '#{scenario.name}' can not be executed on grid hosted Firefox browsers."
    skip_this_scenario
  else
    block.call
  end
end


# supporting methods

def qualify_browser(browser_type, browser_name, scenario, block)
  if Environ.browser != browser_type && ENV['HOST_BROWSER'] != browser_name.downcase
    block.call
  else
    log "Scenario '#{scenario.name}' cannot be executed with the #{browser_name} browser."
    skip_this_scenario
  end
end

def qualify_device(device, scenario, block)
  if Environ.is_device?
    if Environ.device_type.include? device
      log "Scenario '#{scenario.name}' cannot be executed on #{device} devices."
      skip_this_scenario
    else
      block.call
    end
  else
    block.call
  end
end

def terminate_session
  Capybara.page.driver.quit
  Capybara.reset_sessions!
  Environ.session_state = :quit
  $driver_scenario_count = 0
end

def screen_shot_and_save_page(scenario)
  timestamp = Time.now.strftime('%Y%m%d%H%M%S%L')
  filename = scenario.nil? ? "Screenshot-#{timestamp}.png" : "Screenshot-#{scenario.__id__}-#{timestamp}.png"
  path = File.join Dir.pwd, 'reports/screenshots/', filename
  save_screenshot path
  log "Screenshot saved at #{path}"
  screen_shot = { path: path, filename: filename }
  Environ.save_screen_shot(screen_shot)
  attach(path, 'image/png') unless scenario.nil?
end

def process_embed_screenshots(scenario)
  screen_shots = Environ.get_screen_shots
  if screen_shots.count > 0
    screen_shots.each do |row|
      path = row[:path]
      attach(path, 'image/png')
    end
  else
    screen_shot_and_save_page(scenario) if scenario.failed?
  end
end
