Given /^a new user$/ do 
end

Given /^the user with name "([^"]*)", email "([^"]*)" and password "([^"]*)"$/ do |name, email, password|
  user = FactoryGirl.create(:user, :first_name => name, :email => email, :password => password)
end

Given /^A user is logged in as "([^\"]*)" with password "([^\"]*)"$/ do |email, password|
  unless username.blank?
    visit login_url
    fill_in "user_email", :with => email
    fill_in "user_password", :with => password   
    within("form") do
       click_on "Sign in"
    end
  end
end

Given /^a logged\-in user with name "([^"]*)", email "([^"]*)" and password "([^"]*)"$/ do |name, email, password|
    user = FactoryGirl.create(:user, :first_name => name, :email => email, :password => password)
    user.save    
    sign_in user
end

Given /^a logged\-in user "([^"]*)"$/ do |name|
    user = FactoryGirl.create(:user, :first_name => name)
    sign_in user
end

Given /^the user with name "([^"]*)"$/ do |name|
  user = FactoryGirl.create(:user, :first_name => name)
end



Given /^the following (.+) records?$/ do |factory, table|
  table.hashes.each do |hash|
    FactoryGirl.create(factory, hash)
  end
end




When /^the user signs up with his name "([^"]*)", email "([^"]*)" and password "([^"]*)"$/ do |first_name , email, password|
  visit "/users/sign_up"
  page.should have_content('Sign up')  
  current_path.should == new_user_registration_path  
  fill_in "user_first_name", :with => first_name
  fill_in "user_last_name", :with => "foo"
  fill_in "user_email", :with => email
  fill_in "user_password", :with => password
  fill_in "user_password_confirmation", :with => password
  click_button('Sign up')  
end

When /^the user signs in with his email "([^"]*)" and password "([^"]*)"$/ do |email, password|
  visit root_path(:locale => "en")
  click_link "Sign in"
  fill_in "user_email", :with => email
  fill_in "user_password", :with => password 
  
  within("form") do
     click_on "Sign in"
  end
end



