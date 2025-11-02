

When(/^I (.*) the (.*) media$/) do |action, media_type|
  media_test_page.perform_action(media_type, action)
end


Then(/^the (.*) media should be (.*)$/) do |media_type, state|
  media_test_page.verify_media_state(media_type, state)
end


When(/^I play the (.*) with a playback speed of (.*)x$/) do |media_type, rate|
  media_test_page.set_playback_rate(media_type, rate)
end


Then(/^the (.*) should play at (.*)x speed$/) do |media_type, rate|
  media_test_page.verify_playback_rate(media_type, rate)
end


When(/^I set the volume of the (.*) to (.*)$/) do |media_type, volume|
  media_test_page.set_volume(media_type, volume)
end


Then(/^the (.*) should have a volume of (.*)$/) do |media_type, volume|
  media_test_page.verify_volume(media_type, volume)
end
