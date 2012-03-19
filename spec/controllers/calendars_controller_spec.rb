require 'spec_helper'
#require 'ruby-debug19'

describe CalendarsController do
  render_views  
  fixtures :users
  fixtures :work_session_times  


  before(:each) do
    @user_ben = users(:ben)
    sign_in @user_ben
  end
  
  it "should create a work session time" do
    start_time = DateTime.current + 1.day
    end_time = DateTime.current + 1.day + 3.hours
    number_of_times = @user_ben.work_session_times.length
    post :new_event, start_time: start_time, end_time: end_time
    @user_ben.work_session_times.count.should eq(number_of_times+1)
  end
  
  it "should deliver the saved session times" do
    data = get :all_events
    body = data.body
    obj = ActiveSupport::JSON.decode(body)
    obj.count.should eq(2) #fixture has two work session times for this user
  end
  
  it "should delete saved session times" do
    tomorrow_morning_10am = work_session_times(:tomorrow_morning_10am)
    number_of_times = @user_ben.work_session_times.length    
    post :remove_event, event: tomorrow_morning_10am.id
    @user_ben.work_session_times.count.should eq(number_of_times-1)          
  end

end
