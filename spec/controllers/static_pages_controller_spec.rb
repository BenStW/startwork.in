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
  
  context "canvas" do   
    before(:each) do 
      @appointment = FactoryGirl.create(:appointment)
      @request_str1 = "my_request_str1"
      Request.create(:appointment=>@appointment, :request_str=>@request_str1)
      @request_str2 = "my_request_str2"
      Request.create(:appointment=>@appointment, :request_str=>@request_str2)
      
      @user = FactoryGirl.create(:user)
      sign_in @user   
    end
    
    it "should assign the appointment based on the request_str" do
      get :canvas, :request_ids=> @request_str1
      assigns[:appointment].should eq(@appointment)
    end
    
    it "should raise an error when no request could be found" do
        expect {
          get :canvas, :request_ids=> "asdf"          
        }.to raise_error
    end
    
    it "should grep the appointment of the last request" do
      request_strs = @request_str1+","+@request_str2
      get :canvas, :request_ids=> request_strs          
      assigns[:appointment].should eq(@appointment)     
    end
    
  
  end
  

  
end
