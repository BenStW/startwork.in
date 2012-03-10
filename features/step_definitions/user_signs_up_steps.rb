Given /^a new user "([^"]*)"$/ do |username|
  @username = username
end

When /^the user populates his data on the sign up site$/ do
  visit "/"
  click_link "Sign in"
  click_link "Sign up"
  page.should have_content('Sign up')  
  current_path.should == new_user_registration_path  
  fill_in "user_name", :with => @username
  fill_in "user_email", :with => "#{@username}@test.com"
  fill_in "user_password", :with => "secret"
  fill_in "user_password_confirmation", :with => "secret"
  click_button('Sign up')
  @user = User.find_by_name(@username)
end

Then /^he succussfully signs up$/ do
  page.should have_content('Welcome! You have signed up successfully') 
end

