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

Given /^his facebook friend "([^"]*)"$/ do |name|
   friends = FbGraph::User.new.fetch.friends
   new_friend = mock("FbGraph::User", :name => name, :identifier => name)
   new_friends = friends.push(new_friend)
   FbGraph::User.stub_chain(:new, :fetch, :friends).and_return(new_friends)
end

When /^the user hits the facebook button$/ do
  visit root_url
#  puts page.html
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




#Given /^the user with name "([^"]*)"$/ do |name|
#  user = FactoryGirl.create(:user, :first_name => name)
#end




#
#Given /^a new user$/ do 
#end
#
#Given /^the user with name "([^"]*)", email "([^"]*)" and password "([^"]*)"$/ do |name, email, password|
#  user = FactoryGirl.create(:user, :first_name => name, :email => email, :password => password)
#end
#
#Given /^A user is logged in as "([^\"]*)" with password "([^\"]*)"$/ do |email, password|
#  unless username.blank?
#    visit login_url
#    fill_in "user_email", :with => email
#    fill_in "user_password", :with => password   
#    within("form") do
#       click_on "Sign in"
#    end
#  end
#end
#
#Given /^a logged\-in user with name "([^"]*)", email "([^"]*)" and password "([^"]*)"$/ do |name, email, password|
#    user = FactoryGirl.create(:user, :first_name => name, :email => email, :password => password)
#    user.save    
#    sign_in user
#end
#
#Given /^a logged\-in user "([^"]*)"$/ do |name|
#    user = FactoryGirl.create(:user, :first_name => name)
#    sign_in user
#end
#
#Given /^the user with name "([^"]*)"$/ do |name|
#  user = FactoryGirl.create(:user, :first_name => name)
#end
#
#
#
#Given /^the following (.+) records?$/ do |factory, table|
#  table.hashes.each do |hash|
#    FactoryGirl.create(factory, hash)
#  end
#end
#
#
#
#
#When /^the user signs up with his name "([^"]*)", email "([^"]*)" and password "([^"]*)"$/ do |first_name , email, password|
#  visit "/users/sign_up"
#  page.should have_content('Sign up')  
#  current_path.should == new_user_registration_path  
#  fill_in "user_first_name", :with => first_name
#  fill_in "user_last_name", :with => "foo"
#  fill_in "user_email", :with => email
#  fill_in "user_password", :with => password
#  fill_in "user_password_confirmation", :with => password
#  click_button('Sign up')  
#end
#
#When /^the user signs in with his email "([^"]*)" and password "([^"]*)"$/ do |email, password|
#  visit root_path(:locale => "en")
#  click_link "Sign in"
#  fill_in "user_email", :with => email
#  fill_in "user_password", :with => password 
#  
#  within("form") do
#     click_on "Sign in"
#  end
#end
#


