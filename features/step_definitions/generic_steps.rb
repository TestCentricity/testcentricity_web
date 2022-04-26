include TestCentricity


Given(/^I am (?:on|viewing) the (.*) page$/) do |page_name|
  # find and load the specified target page
  target_page = PageManager.find_page(page_name)
  target_page.load_page
end


Then(/^I expect the (.*) page to be correctly displayed$/) do |page_name|
  # find and verify that the specified target page is loaded
  target_page = PageManager.find_page(page_name)
  target_page.verify_page_exists
  # verify that target page is correctly displayed
  target_page.verify_page_ui
end


When(/^I populate the form fields$/) do
  PageManager.current_page.populate_form
end


Then(/^I expect the form fields to be correctly populated$/) do
  PageManager.current_page.verify_form_data
end


When(/^I (.*) my changes$/) do | action|
  PageManager.current_page.perform_action(action.downcase.to_sym)
end


Then(/^I expect the tab order to be correct$/) do
  PageManager.current_page.verify_tab_order
end


When(/^I click the (.*) navigation (?:tab|link)$/) do |page_name|
  # find and navigate to the specified target page
  target_page = PageManager.find_page(page_name)
  target_page.navigate_to
end


Then(/^I should (?:see|be on) the (.*) page$/) do |page_name|
  # find and verify that the specified target page is loaded
  target_page = PageManager.find_page(page_name)
  target_page.verify_page_exists
end


Then(/^I expect the (.*) page to be correctly displayed in a new browser tab$/) do |page_name|
  Browsers.switch_to_new_browser_instance
  Environ.set_external_page(true)
  TestCentricity::WebDriverConnect.initialize_browser_size if Environ.headless
  # find and verify that the specified target page is loaded
  target_page = PageManager.find_page(page_name)
  target_page.verify_page_exists
  # verify that target page is correctly displayed
  target_page.verify_page_ui
end


When(/^I (?:access|switch to) the new browser tab$/) do
  Browsers.switch_to_new_browser_instance
end


When(/^I close the current browser window$/) do
  Browsers.close_current_browser_window
  # intercept and accept any JavaScript system or browser modals that may appear
  begin
    page.driver.browser.switch_to.alert.accept
    switch_to_new_browser_instance
  rescue
  end
end


When(/^I close the previous browser window$/) do
  Browsers.close_old_browser_instance
end


When(/^I refresh the current page$/) do
  Browsers.refresh_browser unless Environ.driver == :appium
end


When(/^I navigate back$/) do
  Browsers.navigate_back
end


When(/^I navigate forward$/) do
  Browsers.navigate_forward
end


When(/^I delete all cookies$/) do
  Browsers.delete_all_cookies
end


When(/^I set device orientation to (.*)$/) do |orientation|
  Browsers.set_device_orientation(orientation.downcase.to_sym)
end


When(/^I choose custom select options by typing$/) do
  custom_controls_page.set_select_options
end


When(/^I choose selectlist options by (.*)$/) do |method|
  PageManager.current_page.choose_options_by(method)
end


Then(/^I expect the selected option to be displayed$/) do
  PageManager.current_page.verify_chosen_options
end


When(/^I populate the form fields with (.*)$/) do |reason|
  PageManager.current_page.invalid_data_entry(reason)
end


Then(/^I expect an error to be displayed due to (.*)$/) do |reason|
  PageManager.current_page.verify_entry_error(reason)
end
