When /^he visits the friends page$/ do
  visit friendships_path
end

When /^he adds the user "([^"]*)" as a friend$/ do |user|
    click_link "Add as friend"
end

Then /^the user "([^"]*)" is defined as a friend$/ do |user|
  @user.friendships.first.friend.name == user
end

When /^he removes the user "([^"]*)" as a friend$/ do |user|
  click_link "Remove as friend"
end

Then /^the user "([^"]*)" is not defined as a friend$/ do |user|
  @user.friendships.count == 0
end