require 'spec_helper'

describe CalendarsController do
  render_views  
  fixtures :users
  fixtures :work_sessions
  fixtures :work_session_times  

  it "should create a work session time" do
    user_ben = users(:ben)
    sign_in user_ben
    work_session = work_sessions(:procrastinators)
    start_time = DateTime.current + 1.day
    end_time = DateTime.current + 1.day + 3.hours
    times = work_session.work_session_times.length
    post :new_time, :work_session_id => work_session.id, start_time: start_time, end_time: end_time
    work_session.work_session_times.count.should eq(times+3)
  end
  
  it "should deliver the saved session times" do
    user_ben = users(:ben)
    sign_in user_ben
    work_session = work_sessions(:procrastinators)
#    tomorrow_morning = work_session_times(:tomorrow_morning)
#    data = get :all_times, :work_session_id => work_session.id
#    puts "data1 = #{data}"
  #  work_session.work_session_times.length.should eq(3)
  end


end
