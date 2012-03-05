Given /^a new user "([^"]*)"$/ do |username|

end

When /^Ben populates his data on the sign up site$/ do
  visit "/"
  click_link "sign in"
  click_link "Sign up"
  page.should have_content('Sign up')  
  current_path.should == new_user_registration_path  
  fill_in "user_name", :with => "Ben"
  fill_in "user_email", :with => "Ben@text.com"
  fill_in "user_password", :with => "secret"
  fill_in "user_password_confirmation", :with => "secret"
  click_button('Sign up')
  
end

Then /^he succussfully signs up$/ do
  page.should have_content('Welcome! You have signed up successfully') 
  find('h2').should have_content('Work groups')
end