

Then /^the user "([^"]*)" is defined as a friend$/ do |user|
  @user.friendships.first.friend.name == user
end

When /^he removes the user "([^"]*)" as a friend$/ do |user|
  click_link "Remove as friend"
end

Then /^the user "([^"]*)" is not defined as a friend$/ do |user|
  @user.friendships.count == 0
end