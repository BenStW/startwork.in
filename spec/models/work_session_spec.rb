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
    @work_session.save    
  end
  
  
  it "is creates a tokbox_session when asking if valid" do
    fresh_work_session = WorkSession.new
    fresh_work_session.tokbox_session_id.should be_nil    
    fresh_work_session.should be_valid    
    fresh_work_session.tokbox_session_id.should_not be_nil    
  end

  
  it "shows all events of this week" do
    t = DateTime.current
    start_time_yesterday = DateTime.new(t.year, t.month,t.day-1,t.hour)
    end_time_yesterday = DateTime.new(t.year, t.month,t.day-1,t.hour+1)
    e1 = @work_session.work_session_times.create(start_time:start_time_yesterday, end_time:end_time_yesterday)
    
    start_time_tomorrow = DateTime.new(t.year, t.month,t.day+1,t.hour)
    end_time_tomorrow = DateTime.new(t.year, t.month,t.day+1,t.hour+1)    
    e2 = @work_session.work_session_times.create(start_time:start_time_tomorrow, end_time: end_time_tomorrow)

    times = @work_session.all_events_of_this_week
    times.count.should eq(1)       
  end
  

end
