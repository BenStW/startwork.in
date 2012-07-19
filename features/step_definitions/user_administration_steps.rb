require 'cucumber/rspec/doubles'

Given /^a facebook user "([^"]*)"$/ do |name|
   mock_auth name
end

Given /^a facebook user "([^"]*)" and his friends "([^"]*)"$/ do |name, friends|
    friends = friends.split( /, */ )
    mock_auth name, friends
end

Given /^a logged\-in facebook user "([^"]*)"$/ do |name|
   step "a facebook user \"#{name}\""
   step "the user hits the facebook button"
end

Given /^an already registered facebook user "([^"]*)"$/ do |name|
  step "a facebook user \"#{name}\""
  step "the user hits the facebook button" 
  step "the user hits \"Log out\""
end

Given /^a facebook user "([^"]*)" and his registered friends "([^"]*)"$/ do |name, friends|
  friends.split( /, */ ).each do |friend|
    step "an already registered facebook user \"#{friend}\""
  end
  step "a facebook user \"#{name}\" and his friends \"#{friends}\""

end

Given /^his facebook friend "([^"]*)"$/ do |name|
   friends = FbGraph::User.new.fetch.friends
   new_friend = mock("FbGraph::User", :name => name, :identifier => name)
   new_friends = friends.push(new_friend)
   FbGraph::User.stub_chain(:new, :fetch, :friends).and_return(new_friends)
end

When /^the user hits the facebook button$/ do
  visit root_url
  find("#facebook_link").click
end

When /^the user "([^"]*)" hits the facebook button$/ do |name|
   step "a facebook user \"#{name}\""
   step "the user hits the facebook button"
end

Then /^user "([^"]*)" is created$/ do |name|
  user = User.find_by_first_name(name)
  user.should_not be_nil
end

Then /^user "([^"]*)" is friend with user "([^"]*)"$/ do |name1, name2|
  user1 = User.find_by_first_name(name1)  
  user2 = User.find_by_first_name(name2)
  user1.is_friend?(user2).should eq(true)
end




