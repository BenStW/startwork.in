require 'spec_helper'

describe StaticPagesController do
  
  context "home" do
    
    before(:each) { @user = FactoryGirl.create(:user)}
    
    it "should be success when not logged in" do
       get :home
       response.should be_success 
    end
    
    it "should be success when logged in" do      
      sign_in @user      
      get :home
      response.should be_success 
    end
    
    it "should render home" do   
      get :home
      response.should render_template("home")
    end
  end  
  
  
  context "how it works" do   
    it "should be success" do      
      get :how_it_works
      response.should be_success 
    end   
    it "should render how_it_works" do   
      get :how_it_works
      response.should render_template("how_it_works")
    end  
  end
  
  context "about us" do   
    it "should be success" do      
      get :about_us
      response.should be_success 
    end   
    it "should render about_us" do   
      get :about_us
      response.should render_template("about_us")
    end  
  end
  
  context "welcome" do   
    before(:each) do 
      @user = FactoryGirl.create(:user, :registered=>false)
      sign_in @user   
    end   
   
    it "should be success" do
      get :welcome
      response.should be_success 
    end   
    it "should render welcome" do   
      get :welcome
      response.should render_template("welcome")
    end  
    it "should set the registered attribute to true" do
      @user.registered.should eq(false)
      get :welcome
      @user.reload
      @user.registered.should eq(true)
    end
    it "should redirect to root if user is already registered" do
       @user.registered = true
       @user.save
       get :welcome
       response.should redirect_to(root_path)       
    end
  end  
  
  

  
end
