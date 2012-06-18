
When /^the user goes to "([^"]*)"$/ do |path|
  visit path
end

When /^the user hits "([^"]*)"$/ do |link|
    puts page.html
    click_link link
 #   sleep 10  
end

When /^the user sleeps for "([^"]*)" seconds $/ do |seconds|
    sleep seconds  
end

When /^I attach the file at "([^\"]*)" to "([^\"]*)"$/ do |path, field|
  attach_file(field, path)
end

Then /^the user does not sees "([^"]*)"$/ do |text|
  page.should_not have_content(text)
end

Then /^the user sees "([^"]*)"$/ do |text|
  page.should have_content(text)
end

Then /^the user does not see "([^"]*)"$/ do |text|
  page.should_not have_content(text)
end

Given /^TokBox is unstubbed$/ do
#  TokboxApi.stub_chain(:instance, :generate_session).and_return("tokbox_session_id")  
  TokboxApi.unstub(:instance)
end

