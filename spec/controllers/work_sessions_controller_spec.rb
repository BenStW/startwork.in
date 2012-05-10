require 'spec_helper'

describe WorkSessionsController do
 # render_views
  
  context "show" do
    before(:each) do 
      @user = FactoryGirl.create(:user_with_two_friends_and_same_events)
      @work_session = @user.calendar_events[0].work_session
      sign_in @user   
      tomorrow_10am = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,10)+1.day
      DateTime.stub(:current).and_return(tomorrow_10am)               
    end
    
    it "should be success" do      
      get :show, :id=>@work_session.id
      response.should be_success 
    end   
    
    it "should render show" do   
      get :show, :id=>@work_session.id
      response.should render_template("show")
    end  
    
    it "should assign the tokbox variables" do
      get :show, :id=>@work_session.id
      assigns[:tokbox_session_id].should_not be_nil
      assigns[:tokbox_token].should_not be_nil
      assigns[:tokbox_api_key].should_not be_nil            
    end    
    
    it "should assign the room name" do
      get :show, :id=>@work_session.id
      assigns[:room_name].should eq("#{@work_session.room.user.name}'s room")    
    end
    
    it "should assign the work buddies" do
      get :show, :id=>@work_session.id
      assigns[:work_buddies].should eq(@user.friends)
      assigns[:work_buddies].should eq(@work_session.users-[@user])
    end
    
    it "should raise an exception when work_session does not exist" do
       lambda {get :show, :id=>@work_session.id+100}.should raise_error  
    end
    
    it "should redirect to root if work_session does not belong to user" do
      new_calendar_event = FactoryGirl.build(:calendar_event)
      get :show, :id=>new_calendar_event.work_session.id    
    end

    it "should not allow access to the WorkSession 10 minutes before start" do     
      tomorrow_9_50am = DateTime.current-10.minutes
      DateTime.stub(:current).and_return(tomorrow_9_50am)
      get :show, :id=>@work_session.id
      response.body.should =~ /Please log into the work session maximum 5 minutes before the start./m
    end
    
    it "should not allow access to the WorkSession 5 minutes after the end" do     
      tomorrow_11_05am = DateTime.current+65.minutes
      DateTime.stub(:current).and_return(tomorrow_11_05am)
      get :show, :id=>@work_session.id
      response.body.should =~ /This work session is over./m
    end
      
  end 
  
  context "next" do
    before(:each) do 
      @user = FactoryGirl.create(:user_with_two_friends_and_same_events)
      @work_session = @user.calendar_events[0].work_session
      sign_in @user   
      tomorrow_10am = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,10)+1.day
      DateTime.stub(:current).and_return(tomorrow_10am)               
    end  
    
    it "should redirect to 'show' with the next work_session" do
      get :next
      work_session = @user.calendar_events.next.work_session
      response.should redirect_to(show_work_session_url(work_session))
    end

  end

end
