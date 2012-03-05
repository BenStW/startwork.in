require 'spec_helper'


describe "StaticPages" do
  subject { page }

  
  describe "How it works" do
    it "should have the content 'how it works'" do
      visit how_it_works_url(:locale => :en)
      page.should have_content('How it works')      
    end
   # it "should have the content 'wie es geht'" do
  #    visit how_it_works_url(:locale => :de)
  #    page.should have_content('Wie es geht')      
  #  end
  end  
  
end
