require 'spec_helper'

describe "StaticPages" do
  subject { page }
  describe "Home page" do
    before { visit root_path } 
    
    it { should have_selector('h1', text: "Welcome")}
    
    it "should have the content 'Welcome'" do
      visit '/'
      page.should have_content('Welcome')
    end
    it "should have the right title" do
      visit '/'
      page.should have_selector('title', :text => "StartWork")
    end
  end
  
  describe "How it works" do
    it "should have the content 'how_it_works'" do
      visit '/how_it_works'
      page.should have_content('how_it_works')
    end
  end
  
end
