require 'spec_helper'

describe WorkSessionsController do
 # render_views
  
  context "show" do
    before(:each) do 
      TokboxApi.stub_chain(:instance,:generate_token).and_return("token")
      TokboxApi.stub_chain(:instance,:api_key).and_return("api_key")
            
      @user = FactoryGirl.create(:user_with_two_friends_and_same_events)
      @work_session = @user.calendar_events[0].work_session
      sign_in @user   
      tomorrow_10am = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,10)+1.day
      DateTime.stub(:current).and_return(tomorrow_10am)               
    end
    
    it "should be success" do      
      get :show
      response.should be_success 
    end   
    
    it "should render show" do   
      get :show
      response.should render_template("show")
    end  
    
    it "should assign the tokbox variables" do
      @user.room.tokbox_session_id = "tokbox_session_id"
      @user.room.save
      get :show
      assigns[:tokbox_session_id].should_not be_nil
      assigns[:tokbox_token].should_not be_nil
      assigns[:tokbox_api_key].should_not be_nil            
    end    
    
    it "should assign the room name" do
      get :show
      assigns[:room_name].should eq("#{@work_session.room.user.name}'s room")    
    end
    
 #  it "should assign the work buddies" do
 #    get :show
 #    assigns[:work_buddies].should eq(@user.friends)
 #    assigns[:work_buddies].should eq(@work_session.users-[@user])
 #  end
    
    it "should render the message 'You currently do not have a work session planned.' when 10 minutes before work session" do
      tomorrow_9_50am = DateTime.current-10.minutes
      DateTime.stub(:current).and_return(tomorrow_9_50am)
      get :show
      response.body.should =~ /You currently do not have a work session planned./m
    end
    

    it "should not allow access to the WorkSession 10 minutes before start" do     
      tomorrow_9_50am = DateTime.current-10.minutes
      DateTime.stub(:current).and_return(tomorrow_9_50am)
      get :show
      response.body.should =~ /You currently do not have a work session planned./m
    end
    
    it "should not allow access to the WorkSession 5 minutes after the end" do     
      tomorrow_11_05am = DateTime.current+65.minutes
      DateTime.stub(:current).and_return(tomorrow_11_05am)
      get :show
      response.body.should =~ /You currently do not have a work session planned./m
    end
      
  end 
  
  context "can_we_start" do
    before(:each) do 
      @user = FactoryGirl.create(:user_with_two_friends_and_same_events)
      @work_session = @user.calendar_events[0].work_session
      sign_in @user   
      tomorrow_10am = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,10)+1.day
      DateTime.stub(:current).and_return(tomorrow_10am)               
    end   
    
    it "should render 'true' when the work session starts now" do
      get :can_we_start
      response.body.should eq("true")         
    end    
    
    it "should render 'false' when WorkSession starts in 10 minutes" do     
      tomorrow_9_50am = DateTime.current-10.minutes
      DateTime.stub(:current).and_return(tomorrow_9_50am)
      get :can_we_start
      response.body.should eq("false")   
    end
    
    it "should render 'false' when WorkSession has ended 5 minutes ago" do 
      tomorrow_11_05am = DateTime.current+65.minutes
      DateTime.stub(:current).and_return(tomorrow_11_05am)
      get :can_we_start
      response.body.should eq("false")   
    end     
  end
  
  context "room_change" do
    before(:each) do 
      @user = FactoryGirl.create(:user_with_two_friends_and_same_events)
      @work_session = @user.calendar_events[0].work_session
      sign_in @user   
      tomorrow_10am = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,10)+1.day
      DateTime.stub(:current).and_return(tomorrow_10am)               
    end   
    
    it "should render 'false' when the work_session has the same session" do
      get :room_change, :session=>@work_session.room.tokbox_session_id
      response.body.should eq("false")         
    end    
     
    it "should render 'true' when WorkSession starts in 10 minutes" do     
      tomorrow_9_50am = DateTime.current-10.minutes
      DateTime.stub(:current).and_return(tomorrow_9_50am)
      get :room_change, :session=>@work_session.room.tokbox_session_id
      response.body.should eq("true")   
    end
    
    it "should render 'true' when WorkSession has ended 5 minutes ago" do 
      tomorrow_11_05am = DateTime.current+65.minutes
      DateTime.stub(:current).and_return(tomorrow_11_05am)
      get :room_change, :session=>@work_session.room.tokbox_session_id
      response.body.should eq("true")   
    end     
  end  
  
  context "get_time" do
    before(:each) do 
      @user = FactoryGirl.create(:user)
      sign_in @user      
      @tomorrow_10am = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,10)+1.day
      DateTime.stub(:current).and_return(@tomorrow_10am)               
    end   
    
    it "should render the server time" do      
     get :get_time
     response.body.should eq(@tomorrow_10am.to_json)
     response.should be_success 
    end  
  end

end
