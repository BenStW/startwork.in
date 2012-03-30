require 'spec_helper'
#require 'ruby-debug19'

describe CalendarEventsController do
  render_views  

  before(:each) do
    @user = FactoryGirl.create(:user_with_two_friends_and_same_events)
    sign_in @user
  end
  
  it "should create two calendar events for two hours" do
    start_time = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,10)+2.days
    end_time = start_time + 2.hours    
    number_of_events = @user.calendar_events.length
    post :new_event, start_time: start_time, end_time: end_time
    @user.calendar_events.count.should eq(number_of_events+2)
  end
  
  it "should deliver the saved calendar events for my calendar" do  
    data = get :get_events
    body = data.body
    obj = ActiveSupport::JSON.decode(body)

    #Factory has one calendar event for this user
    obj["events"].count.should eq(1) 
  end
  
  it "should deliver the saved calendar events for all my friends" do  
    data = get :get_events, :user_ids => "all"
    body = data.body
    obj = ActiveSupport::JSON.decode(body)
    
    #Factory has one calendar event for this user and two equal calendar events for his friends
    obj["events"].count.should eq(2) 
  end
  
  it "should deliver the saved calendar events for my specified friends" do  
    friend_ids = @user.friendships.map(&:friend).map(&:id).join(",")
    data = get :get_events, :user_ids => friend_ids
    body = data.body
    obj = ActiveSupport::JSON.decode(body)
    
    #Factory has one calendar event for this user and two for his friends
    obj["events"].count.should eq(3) 
  end
  
  it "should delete saved calendar event" do     
     calendar_event = @user.calendar_events.first
     work_session = calendar_event.find_or_create_work_session!    
     post :remove_event, event: calendar_event.id
     @user.calendar_events.count.should eq(0)          
  end

end
