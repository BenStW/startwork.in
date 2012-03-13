require 'spec_helper'
#require 'ruby-debug19'

describe CalendarsController do
  render_views  
  fixtures :users
  fixtures :work_sessions
  fixtures :work_session_times  
  
  before(:each) do
    user_ben = users(:ben)
    sign_in user_ben
    @work_session = work_sessions(:procrastinators)
  end

  it "should create a work session time" do
    start_time = DateTime.current + 1.day
    end_time = DateTime.current + 1.day + 3.hours
    times = @work_session.work_session_times.length
    post :new_event, :work_session_id => @work_session.id, start_time: start_time, end_time: end_time
    @work_session.work_session_times.count.should eq(times+1)
  end
  
  it "should deliver the saved session times" do
    tomorrow_morning_10am = work_session_times(:tomorrow_morning_10am)
    tomorrow_morning_11am = work_session_times(:tomorrow_morning_11am)
    data = get :all_events, :work_session_id => @work_session.id
    body = data.body
    obj = ActiveSupport::JSON.decode(body)
    obj.count.should eq(2)
  end
  
  it "should delete saved session times" do
    tomorrow_morning_10am = work_session_times(:tomorrow_morning_10am)
    tomorrow_morning_11am = work_session_times(:tomorrow_morning_11am)    
    start_time = tomorrow_morning_10am.start_time
    end_time = tomorrow_morning_11am.start_time + 1.hour
    times = @work_session.work_session_times.length    
    post :remove_event, :work_session_id => @work_session.id, event: tomorrow_morning_10am.id
    @work_session.work_session_times.count.should eq(times-1)          
  end
end
