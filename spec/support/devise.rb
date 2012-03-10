RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
end

def sign_in(user)
  visit root_path
  click_link "Sign in"
  fill_in "user_email", :with => user.email
  fill_in "user_password", :with => "secret"  
  within("form") do
     click_on "Sign in"
  end
end