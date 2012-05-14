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
    
    it "should not assign a work session if the latest was yesterday" do
      sign_in @user   
      yesterday_start_time = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,10)-1.day
      calendar_event = Factory.create(:calendar_event,:user=>@user, :start_time => yesterday_start_time)         
      get :home
      assigns(:next_work_session).should eq(nil)        
    end    
    
    it "should assign the next work session" do
      sign_in @user
      calendar_event = Factory.create(:calendar_event,:user=>@user)
      get :home
      assigns(:next_work_session).should eq(calendar_event.work_session)      
    end
    
    it "should assign the next work session when it has started 10 minutes ago" do
      tomorrow_10_10am = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,10)+1.day+10.minutes
      DateTime.stub(:current).and_return(tomorrow_10_10am) 
      sign_in @user
      calendar_event = Factory.create(:calendar_event,:user=>@user)
      get :home
      assigns(:next_work_session).should eq(calendar_event.work_session)      
    end
    
    it "should not assign the next work session when it has started 65 minutes ago" do
      tomorrow_11_05am = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,10)+1.day+65.minutes
      DateTime.stub(:current).and_return(tomorrow_11_05am) 
      calendar_event = Factory.create(:calendar_event,:user=>@user)
      get :home
      assigns(:next_work_session).should eq(nil)      
      
    end
      
    
    it "should assign room host" do
      sign_in @user
      calendar_event = Factory.create(:calendar_event,:user=>@user)
      get :home
      assigns(:room_host).should eq(@user.name)      
    end
    
    it "should assign user_names 'no WorkBuddies yet' when no work buddies " do
      sign_in @user
      calendar_event = Factory.create(:calendar_event,:user=>@user)
      get :home
      assigns(:user_names).should eq("No WorkBuddies yet")      
    end
    
    it "should assign the comma separated user_names when work buddies " do
      user = Factory.create(:user_with_two_friends_and_same_events)
      sign_in user
      get :home
      user_names = "with " + user.friends.map(&:name).join(", ")
      assigns(:user_names).should eq(user_names)      
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
  
  context "contact" do   
    it "should be success" do      
      get :contact
      response.should be_success 
    end   
    it "should render contact" do   
      get :contact
      response.should render_template("contact")
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
  
  context "camera" do
    before(:each) do 
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

    it "should be success" do      
      get :camera
      response.should be_success 
    end   
    it "should render camera" do   
      get :camera
      response.should render_template("camera")
    end  
    it "should redirect to audio when test was successful" do
      get :camera, :success=>true
      response.should redirect_to(audio_path)
    end
  end
  
  context "audio" do
    before(:each) do 
      @user = FactoryGirl.create(:user)
      sign_in @user
    end        
    it "should be success" do      
      get :audio
      response.should be_success 
    end   
    it "should render camera" do   
      get :audio
      response.should render_template("audio")
    end  
    it "should redirect to root" do
      get :audio, :success=>true
      response.should redirect_to(root_path)
    end    
  end
  
  
end