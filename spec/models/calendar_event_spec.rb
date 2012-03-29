# == Schema Information
#
# Table name: calendar_events
#
#  id              :integer         not null, primary key
#  user_id         :integer
#  start_time      :datetime
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  work_session_id :integer
#

require 'spec_helper'

describe CalendarEvent do

  before(:each) do
    @calendar_event = FactoryGirl.create(:calendar_event)
  end
 
  it "should be valid with start_time " do
    @calendar_event.start_time.should_not be_nil
    @calendar_event.should be_valid    
  end
  
  it "should not be valid without start_time" do
    @calendar_event.start_time = nil
    @calendar_event.should_not be_valid
  end

  it "should not be valid without user" do
    @calendar_event.user_id = nil
    @calendar_event.should_not be_valid    
  end
  
  it "finds an existing work_session" do
    work_session = FactoryGirl.create(:work_session)
    WorkSession.stub(:find_work_session).and_return(work_session)
    @calendar_event.find_or_create_work_session!  
    @calendar_event.work_session.should == work_session
  end
  it "creates a work_session when no existing" do
    #work_session = FactoryGirl.create(:work_session)
    WorkSession.stub(:find_work_session).and_return(nil)
    @calendar_event.find_or_create_work_session!  
    @calendar_event.work_session.should_not be_nil
  end

 
 end

