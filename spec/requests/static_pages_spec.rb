require 'spec_helper'


describe "StaticPages" do
  fixtures :users
  subject { page }

  
  describe "How it works" do
    it "should have the content 'how it works'" do
      visit how_it_works_url(:locale => :en)
      page.should have_content('How it works')      
    end
  end
  
  describe "the homepage" do
    it "should have the content 'curiosity is the driver of learning'" do
      visit root_url
      page.should have_content('Curiosity is the driver of learning')      
    end
    it "should show work groups when activated user logged in" do
      user_ben = users(:ben)
      sign_in user_ben
      page.should have_content('Signed in successfully') 
      page.should have_content('Work groups') 
    end     
    it "should show not activated message when user not activated" do
      user_steffi = users(:steffi)
      sign_in user_steffi
      page.should have_content('Signed in successfully') 
      page.should have_content('Your account is not activated yet') 
    end     
  end

  
end
