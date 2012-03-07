Given /^the user "([^"]*)"$/ do |arg1|
  user = User.new
  user.name = "Ben"
  user.email = "test@test.com"
  user.password = "secret"
  user.password_confirmation = "secret"
  user.save
  
end

When /^he signs in$/ do
  visit root_path(:locale => "en")
  click_link "Sign in"
  fill_in "user_email", :with => "test@test.com"
  fill_in "user_password", :with => "secret" 
  click_on "Sign in"
end

Then /^he can see his personalized homepage$/ do
  page.should have_content('Signed in successfully') 
  find('h2').should have_content('Work groups')
end