require 'spec_helper'
#require 'ruby-debug19'

describe CalendarEventsController do
  #render_views  
  
 context "show" do
   before(:each) do
     @user = FactoryGirl.create(:user_with_two_friends_and_same_events)
     sign_in @user
   end
   
   it "should be success" do      
     get :show
     response.should be_success 
   end   
   
   it "should render 'show'" do   
     get :show
     response.should render_template("show")
   end
   
   it "should assign friends" do
     friends = @user.friends
     get :show
     assigns(:friends).should eq(friends)       
   end
   
   it "should assign work_sessions" do
     work_session = @user.calendar_events[0].work_session
     get :show
     assigns(:work_sessions).should eq([work_session])
   end    
 end
 
 context "new_event" do
   before(:each) do
     @user = FactoryGirl.create(:user)
     @start_time = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,10)+1.day
     sign_in @user
   end
   
   it "should be success" do      
     get :new_event, start_time: @start_time, end_time: @start_time+1.hour
     response.should be_success 
   end   
   
   it "should create a calendar event" do
     @user.calendar_events.count.should eq(0)
     get :new_event, start_time: @start_time, end_time: @start_time+1.hour
     @user.calendar_events.count.should eq(1)
   end
   
   it "should create two calendar events" do
     @user.calendar_events.count.should eq(0)
     get :new_event, start_time: @start_time, end_time: @start_time+2.hour
     @user.calendar_events.count.should eq(2)
   end    
   
   it "should raise exception when events are not in the hour" do      
     lambda {get :new_event, start_time: @start_time+30.minutes, end_time: @start_time+30.minutes}.should raise_error
     @user.calendar_events.count.should eq(0)
   end  
   
   it "should create a work_session to the calendar event" do  
     @user.calendar_events.count.should eq(0)
     get :new_event, start_time: @start_time, end_time: @start_time+1.hour
     @user.calendar_events[0].work_session.should_not eq(nil)   
   end
   
   it "should find an existing work_session if a friend has a calendar_event at this time" do
     friend = FactoryGirl.create(:user)
     calendar_event = FactoryGirl.create(:calendar_event, :user=>friend, :start_time=>@start_time)
     friendship = FactoryGirl.create(:friendship, :user=>@user, :friend=>friend)
     inv_friendship = FactoryGirl.create(:friendship, :user=>friend, :friend=>@user)      
     get :new_event, start_time: @start_time, end_time: @start_time+1.hour
     @user.calendar_events[0].work_session.should eq(calendar_event.work_session)
   end
   
   it "should find an existing work_session if another user has a calendar_event at this time" do
     friend = FactoryGirl.create(:user)
     calendar_event = FactoryGirl.create(:calendar_event, :user=>friend, :start_time=>@start_time)
     get :new_event, start_time: @start_time, end_time: @start_time+1.hour
     @user.calendar_events[0].work_session.should eq(calendar_event.work_session)
   end
   
   it "should not find an existing work_session if a friend has calendar_event at a different time" do
     friend = FactoryGirl.create(:user)
     calendar_event = FactoryGirl.create(:calendar_event, :user=>friend, :start_time=>@start_time)
     friendship = FactoryGirl.create(:friendship, :user=>@user, :friend=>friend)
     inv_friendship = FactoryGirl.create(:friendship, :user=>friend, :friend=>@user)      
     get :new_event, start_time: @start_time+1, end_time: @start_time+2.hour
     @user.calendar_events[0].work_session.should_not eq(calendar_event.work_session)
   end
 end
 
 context "events" do
   
   before(:each) do
     @user = FactoryGirl.create(:user_with_two_friends_and_same_events)
     sign_in @user
   end
   
   it "should be success" do      
     get :events
     response.should be_success 
   end   
   
   it "should show my calendar event and of my friends" do   
     data = get :events
     body = data.body
     obj = ActiveSupport::JSON.decode(body)
     obj.count.should eq(3)
   end    
   
   it "should show my calendar event with 3 fields (id, user_id and start_time)" do  
     calendar_event = @user.calendar_events[0] 
     data = get :events
     body = data.body
     obj = ActiveSupport::JSON.decode(body)
     json_calendar_event = obj[0]
     json_calendar_event["id"].should eq(calendar_event.id)
     json_calendar_event["user_id"].should eq(@user.id)      
     DateTime.parse(json_calendar_event["start_time"]).should eq(calendar_event.start_time)
   end   
       
 end
 
 
 context "send_invitation" do
   
   before(:each) do
      @user = FactoryGirl.create(:user_with_two_friends_and_same_events)
      sign_in @user
      single_ws_start_time = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,10)+2.days   
      calendar_event = FactoryGirl.create(:calendar_event, :user=>@user, :start_time=>single_ws_start_time) 
      WorkSession.stub(:single_work_sessions_with_user_id).and_return([calendar_event.work_session])      
   end
   
   it "should render nothing when no user_ids given" do
     get :send_invitation
     response.should be_success
     response.body.should eq("succussfully sent invitation") 
   end
   
   it "should create a CalendarInvitation" do     
     get :send_invitation
     CalendarInvitation.all.count.should eq(1)
   end
   
   it "should find the single worksessions of the user" do
     WorkSession.should_receive(:single_work_sessions_with_user_id).with(@user.id)
     get :send_invitation         
   end
   
   it "should create and send a CalendarInvitationMailer for each registered friend" do
     email = mock CalendarInvitationMailer
     CalendarInvitationMailer.stub(:calendar_invitation_email).and_return(email)
     email.stub(:deliver)
     email.should_receive(:deliver)     
     CalendarInvitationMailer.should_receive(:calendar_invitation_email).exactly(2).times 
     get :send_invitation
   end
   
   it "should not create and send a CalendarInvitationMailer for not registered friend" do
      @user.friends.each do |friend|
        friend.registered = false
        friend.save
      end
      CalendarInvitationMailer.should_receive(:calendar_invitation_email).exactly(0).times       
      get :send_invitation
   end   
  
 end
 
 
  context "remove_event" do
    
    before(:each) do
       @user = FactoryGirl.create(:user_with_two_friends_and_same_events)
       sign_in @user
    end
    
    it "should delete saved calendar event" do     
       calendar_event = @user.calendar_events.first
       get :remove_event, event: calendar_event.id
       @user.calendar_events.count.should eq(0)          
    end
    
    it "should raise an exception when trying to delete a calendar event of another user" do
       CalendarEvent.all.count.should eq(3)       
       foreign_calendar_event = @user.friends[0].calendar_events[0]
       lambda {get :remove_event, event: foreign_calendar_event.id}.should raise_error
       CalendarEvent.all.count.should eq(3)       
    end
    
    it "should reassign a new work session for the friends when calendar event is deleted" do
      own_calendar_event = @user.calendar_events.first
      own_work_session = own_calendar_event.work_session
      @user.friends do |friend|
        friend.calendar_events[0].work_session.should eq(own_work_session)
      end
      get :remove_event, event: own_calendar_event.id
      friend1 = @user.friends[0]
      friend2 = @user.friends[1]
      friend1.calendar_events[0].work_session.should eq(friend2.calendar_events[0].work_session)
    end
   
 end

end
