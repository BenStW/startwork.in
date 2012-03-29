
When /^he removes the user "([^"]*)" as a friend$/ do |user|
  click_link "Remove as friend"
end

When /^the user adds "([^"]*)" as a work\-buddy$/ do |friend|
  find('#'+friend).click_link("Add as work-buddy")
end

When /^the user removes "([^"]*)" as a work\-buddy$/ do |friend|
 find('#'+friend).click_link("Remove as work-buddy")
end


Then /^the user "([^"]*)" is defined as a friend$/ do |user|
  @user.friendships.first.friend.name == user
end



Then /^the user "([^"]*)" is not defined as a friend$/ do |user|
  @user.friendships.count == 0
end

Then /^the user "([^"]*)" is shown as work\-buddy$/ do |friend|
   find('#'+friend).find('a', :text => "Remove as work-buddy")
end


Then /^the user "([^"]*)" is not shown as work\-buddy$/ do |friend|
   find('#'+friend).find('a', :text => "Add as work-buddy")
end