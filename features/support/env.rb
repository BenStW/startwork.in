# IMPORTANT: This file is generated by cucumber-rails - edit at your own peril.
# It is recommended to regenerate this file in the future when you upgrade to a 
# newer version of cucumber-rails. Consider adding your own code to a new file 
# instead of editing this one. Cucumber will automatically load all features/**/*.rb
# files.

require 'cucumber/rails'
#require 'factory_girl/step_definitions'

# Capybara defaults to XPath selectors rather than Webrat's default of CSS3. In
# order to ease the transition to Capybara we set the default here. If you'd
# prefer to use XPath just remove this line and adjust any selectors in your
# steps to use the XPath syntax.
Capybara.default_selector = :css

# By default, any exception happening in your Rails application will bubble up
# to Cucumber so that your scenario will fail. This is a different from how 
# your application behaves in the production environment, where an error page will 
# be rendered instead.
#
# Sometimes we want to override this default behaviour and allow Rails to rescue
# exceptions and display an error page (just like when the app is running in production).
# Typical scenarios where you want to do this is when you test your error pages.
# There are two ways to allow Rails to rescue exceptions:
#
# 1) Tag your scenario (or feature) with @allow-rescue
#
# 2) Set the value below to true. Beware that doing this globally is not
# recommended as it will mask a lot of errors for you!
#
ActionController::Base.allow_rescue = false

# Remove/comment out the lines below if your app doesn't have a database.
# For some databases (like MongoDB and CouchDB) you may need to use :truncation instead.
begin
  DatabaseCleaner.strategy = :transaction
rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
end

# You may also want to configure DatabaseCleaner to use different strategies for certain features and scenarios.
# See the DatabaseCleaner documentation for details. Example:
#
#   Before('@no-txn,@selenium,@culerity,@celerity,@javascript') do
#     DatabaseCleaner.strategy = :truncation, {:except => %w[widgets]}
#   end
#
#   Before('~@no-txn', '~@selenium', '~@culerity', '~@celerity', '~@javascript') do
#     DatabaseCleaner.strategy = :transaction
#   end
#

# Possible values are :truncation and :transaction
# The :transaction strategy is faster, but might give you threading problems.
# See https://github.com/cucumber/cucumber-rails/blob/master/features/choose_javascript_database_strategy.feature
Cucumber::Rails::Database.javascript_strategy = :truncation

Capybara::Node::Element.class_eval do
  def click_at(x, y)
    wait_until do
      right = x - (native.size.width / 2)
      top = y - (native.size.height / 2)
      puts "x = #{x}"
      puts "y = #{y}"
      puts "native.size.width = #{native.size.width }"
      puts "native.size.height = #{native.size.height }"
      puts "right = #{right}"
      puts "top = #{top}"
      right= 10
      top =10
      puts native.size.to_yaml
      driver.browser.action.move_to(native).move_by(right.to_i, top.to_i).click.perform
    end
  end 
end

def log_out
  page.driver.delete destroy_user_session_path
end


#def sign_in(user)
#  visit root_path
#  click_link "Sign in"
#  fill_in "user_email", :with => user.email
#  fill_in "user_password", :with => "secret" #user.password 
#  within("form") do
#     click_on "Sign in"
#  end
#end

def sign_up(name)
    user = FactoryGirl.create(:user, :name => name)
    user.save
    sign_in user
end


def mock_auth(name,friends=[])
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:facebook] = {
      :provider => 'facebook',
    }
    mock_extra = mock("mock_extra",
       :raw_info => 
         mock("mock_raw_info",
         :id => name, #store the name as Facebook unique id
         :email => "#{name}@startwork.in",
         :first_name => name,
         :last_name => "xyz"))
          
    OmniAuth.config.mock_auth[:facebook].stub(:extra).and_return(mock_extra) 
    OmniAuth.config.mock_auth[:facebook].stub_chain(:credentials,:token).and_return("my token")   
    
    friends_mock = []
    friends.each do |friend|
      friend_mock = mock("FbGraph::User", :name => friend, :identifier => friend)
      friends_mock.push(friend_mock)
    end
    FbGraph::User.stub_chain(:new, :fetch, :friends).and_return(friends_mock) 
    TokboxApi.stub_chain(:instance, :generate_session).and_return("tokbox_session_id")
end
