require 'spec_helper'

describe GroupHoursController do
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
   #   @user.room.tokbox_session_id = "tokbox_session_id"
   #   @user.room.save
      get :show
      assigns[:tokbox_session_id].should_not be_nil
      assigns[:tokbox_token].should_not be_nil
      assigns[:tokbox_api_key].should_not be_nil            
    end    
    
    it "should assign the room name" do
      get :show
      assigns[:room_name].should eq("#{@work_session.room.user.name}'s room")    
    end
    
    it "should create a calendar_event when 10 minutes (9:50) before work session" do
      tomorrow_9_50am = DateTime.current-10.minutes      
      DateTime.stub(:current).and_return(tomorrow_9_50am)
      expect {  get :show }.to change(CalendarEvent, :count).by(1)
      tomorrow_9_00am = DateTime.current-50.minutes   
      calendar_event = CalendarEvent.find_by_start_time(tomorrow_9_00am)
      calendar_event.should_not be_nil
    end
    it "should not create a calendar_event when 3 minutes (9:57) before the start" do 
      tomorrow_9_57am = DateTime.current-3.minutes      
      DateTime.stub(:current).and_return(tomorrow_9_57am)
      expect {  get :show }.to change(CalendarEvent, :count).by(0)
    end  
    it "should not create a calendar_event when 3 minutes (10:57) before the end" do 
     tomorrow_10_57am = DateTime.current+57.minutes      
     DateTime.stub(:current).and_return(tomorrow_10_57am)
     expect {  get :show }.to change(CalendarEvent, :count).by(0)
   end      
    
    it "should create a calendar_event when 5 minutes (11:05) after the end" do     
      tomorrow_11_05am = DateTime.current+65.minutes
      DateTime.stub(:current).and_return(tomorrow_11_05am)
      expect {  get :show }.to change(CalendarEvent, :count).by(1)
      tomorrow_11_00am = DateTime.current-5.minutes   
      calendar_event = CalendarEvent.find_by_start_time(tomorrow_11_00am)
      calendar_event.should_not be_nil      
    end

        
    it "should store the login count of 1" do
      get :show
      @user.calendar_events.first.reload    
      @user.calendar_events.first.login_count.should eq(1)     
    end
    it "should not store the login count if no work_session" do      
      tomorrow_11_05am = DateTime.current+65.minutes
      DateTime.stub(:current).and_return(tomorrow_11_05am)
      get :show
      @user.calendar_events.first.reload    
      @user.calendar_events.first.login_count.should be_nil      
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
    
    it "should not create a new CalendarEvent" do     
      expect { get :room_change, :session=>@work_session.room.tokbox_session_id }.to change(CalendarEvent, :count).by(0)
      response.body.should eq("false")         
    end
     
    it "should create new CalendarEvent when session starts in 10 minutes" do     
      tomorrow_9_50am = DateTime.current-10.minutes
      DateTime.stub(:current).and_return(tomorrow_9_50am)
      expect { get :room_change, :session=>@work_session.room.tokbox_session_id }.to change(CalendarEvent, :count).by(1)
      response.body.should eq("false")         
    end
    
    it "should create new CalendarEvent when session ended 10 minutes ago" do     
      tomorrow_11_10am = DateTime.current+70.minutes
      DateTime.stub(:current).and_return(tomorrow_11_10am)
      expect { get :room_change, :session=>@work_session.room.tokbox_session_id }.to change(CalendarEvent, :count).by(1)
      response.body.should eq("false")         
    end    
    
    it "should  render 'true'  when no session is passed" do     
      get :room_change
      response.body.should eq("true")         
    end    
     
    it "should render 'true' when WorkSession is in a new room" do       
      get :room_change, :session=>"old_tokbox_session_id"    
      response.body.should eq("true")   
    end  
    it "should store the login when current WorkSession is given" do
      CalendarEvent.any_instance.should_receive(:store_login).exactly(1).times
      get :room_change, :session=>@work_session.room.tokbox_session_id      
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
