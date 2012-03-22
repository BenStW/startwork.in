require 'spec_helper'
#require 'ruby-debug19'

describe CalendarsController do
  render_views  

  before(:each) do
    @user = FactoryGirl.create(:user_with_two_friends_and_overlapping_times)
    sign_in @user
  end
  
  it "should create a work session time" do
    start_time = DateTime.current + 1.day
    end_time = DateTime.current + 1.day + 3.hours
    number_of_times = @user.work_session_times.length
    post :new_event, start_time: start_time, end_time: end_time
    @user.work_session_times.count.should eq(number_of_times+1)
  end
  
  it "should deliver the saved session times for my calendar" do  
    data = get :get_events
    body = data.body
    obj = ActiveSupport::JSON.decode(body)
    obj["events"].count.should eq(1) #Factory has one work session time for this user
  end
  
  it "should deliver the saved session times for all my friends" do  
    data = get :get_events, :user_ids => "all"
    body = data.body
    obj = ActiveSupport::JSON.decode(body)
    obj["events"].count.should eq(2) #Factory has one work session time for this user and two for his friends, which get merged
  end
  
  it "should deliver the saved session times for my specified friends" do  
    friend_ids = @user.friendships.map(&:friend).map(&:id).join(",")
    data = get :get_events, :user_ids => friend_ids
    body = data.body
    obj = ActiveSupport::JSON.decode(body)
    obj["events"].count.should eq(3) #Factory has one work session time for this user and two for his friends
  end
  
  it "should delete saved session times" do
     work_session_time = @user.work_session_times.first
     post :remove_event, event: work_session_time.id
     @user.work_session_times.count.should eq(0)          
  end

end
