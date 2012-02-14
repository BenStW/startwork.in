require 'spec_helper'

describe "StaticPages" do
  describe "Home page" do
    it "should have the content 'Welcome'" do
      visit '/'
      page.should have_content('Welcome')
    end
    it "should have the right title" do
      visit '/'
      page.should have_selector('title', :text => "StartWork")
    end
  end
end
