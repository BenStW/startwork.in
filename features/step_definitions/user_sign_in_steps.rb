Given /^a new user$/ do 
end

Given /^the user with name "([^"]*)", email "([^"]*)" and password "([^"]*)"$/ do |name, email, password|
  user = FactoryGirl.create(:user, :name => name, :email => email, :password => password)
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

Given /^an active, logged\-in user with name "([^"]*)", email "([^"]*)" and password "([^"]*)"$/ do |name, email, password|
    user = FactoryGirl.create(:user, :name => name, :email => email, :password => password)
    user.activated=true
    user.save    
    sign_in user
end

Given /^an active, logged\-in user "([^"]*)"$/ do |name|
    user = FactoryGirl.create(:user, :name => name)
    user.activated=true
    user.save
    sign_in user
end

Given /^the active user with name "([^"]*)"$/ do |name|
  user = FactoryGirl.create(:user, :name => name, :activated=>true)
end



Given /^the following (.+) records?$/ do |factory, table|
  table.hashes.each do |hash|
    FactoryGirl.create(factory, hash)
  end
end




When /^the user signs up with his name "([^"]*)", email "([^"]*)" and password "([^"]*)"$/ do |name, email, password|
  visit "/users/sign_up"
  page.should have_content('Sign up')  
  current_path.should == new_user_registration_path  
  fill_in "user_name", :with => name
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


When /^the user "([^"]*)" is activated$/ do |name|
  user = User.find_by_name(name)
  user.activated = true
  user.save  
end



