# == Schema Information
#
# Table name: work_sessions
#
#  id                :integer         not null, primary key
#  tokbox_session_id :string(255)
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#

require 'spec_helper'

describe WorkSession do
  before(:each) do
    @work_session = WorkSession.new
    @work_session.tokbox_session_id ="asdf"
    @work_session.save    
  end
  
  it "is not valid without tokbox_session" do
    fresh_work_session = WorkSession.new
    fresh_work_session.should_not be_valid
  end
  
  it "is valid with a tokbox_session" do
    fresh_work_session = WorkSession.new
    fresh_work_session.should_not be_valid    
    fresh_work_session.tokbox_session_id ="asdf"
    fresh_work_session.should be_valid
  end
  
  it "creates a tokbox_token" do
    fresh_work_session = WorkSession.new
    fresh_work_session.generate_tokbox_session
    connection_data = {:user_id =>1, :user_name => "Ben"}
    tokbox_token = fresh_work_session.generate_tokbox_token(connection_data)
    tokbox_token.should_not be_nil
  end
  
  it "creates one work session time" do
    t = DateTime.current
    time = DateTime.new(t.year, t.month,t.day,t.hour)
    @work_session.create_work_session_times(time)   
    @work_session.work_session_times.length.should eq(1)
  end
 
  it "creates several work session times" do
    t = DateTime.current
    start_time = DateTime.new(t.year, t.month,t.day,t.hour)
    end_time = DateTime.new(t.year, t.month,t.day,t.hour+3)
    @work_session.create_work_session_times(start_time, end_time)
    @work_session.work_session_times.length.should eq(3)
  end

  it "shows all times of this week" do
    t = DateTime.current
    start_time_yesterday = DateTime.new(t.year, t.month,t.day-1,t.hour)
    @work_session.create_work_session_times(start_time_yesterday)
    start_time_tomorrow = DateTime.new(t.year, t.month,t.day+1,t.hour)
    @work_session.create_work_session_times(start_time_tomorrow)

    times = @work_session.all_times_of_this_week
    times.count.should eq(1)    
    
  end

end
