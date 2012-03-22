
When /^the user goes to "([^"]*)"$/ do |path|
  visit path
end

When /^the user presses "([^"]*)"$/ do |link|
    click_link link
end

When /^I attach the file at "([^\"]*)" to "([^\"]*)"$/ do |path, field|
  attach_file(field, path)
end

Then /^the user does not sees "([^"]*)"$/ do |text|
  page.should_not have_content(text)
end

Then /^the user sees "([^"]*)"$/ do |text|
  page.has_content?(text)
end

