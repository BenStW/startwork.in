Given /^the user "([^"]*)"$/ do |username|
  @user = User.new
  @user.name = username
  @user.email = "#{username}@test.com"
  @user.password = "secret"
  @user.password_confirmation = "secret"
  @user.save
  
end

When /^he signs in$/ do
  visit root_path(:locale => "en")
  click_link "Sign in"
  fill_in "user_email", :with => @user.email
  fill_in "user_password", :with => @user.password 
  
  within("form") do
     click_on "Sign in"
  end
end


Then /^the user sees the work groups$/ do
  visit "/" #reload, as the model might have been altered by direct model access  
  find('h2').should have_content('Work groups')
#page.find('#table').should have_text('stuff')

#  puts page.html
#  page.should have_css('h2', :text => 'Work groups')
  
end


Given /^the user is activated$/ do
  @user.activated = true
  @user.save  
end

Then /^he sees the not activated message$/ do
  visit "/" #reload, as the model might have been altered by direct model access    
  find('h2').should have_content('Your account is not activated yet.')
end