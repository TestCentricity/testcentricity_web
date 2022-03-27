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
