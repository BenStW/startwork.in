require 'spec_helper'

describe WorkSessionsController do
#  render_views
  
  context "show" do
    before(:each) do 
      @user = FactoryGirl.create(:user_with_two_friends_and_same_events)
      @work_session = @user.calendar_events[0].work_session
      sign_in @user            
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
      response.should redirect_to(root_path)         
    end
  end 

end
