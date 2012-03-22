# == Schema Information
#
# Table name: work_session_times
#
#  id              :integer         not null, primary key
#  work_session_id :integer
#  start_time      :datetime
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  end_time        :datetime
#  user_id         :integer
#

require 'spec_helper'

describe WorkSessionTime do
  fixtures :users   

  before(:each) do
    user_ben = FactoryGirl.create(:user)
    @work_session_time = WorkSessionTime.new
    c = DateTime.current
    @work_session_time.start_time = c
    @work_session_time.end_time = c + 1.hour
    @work_session_time.user_id = user_ben
  end
  
  it "should be valid with valid attributes " do
    @work_session_time.should be_valid    
  end
  
  it "should not be valid without start_time" do
    @work_session_time.start_time = nil
    @work_session_time.should_not be_valid
  end
  it "should not be valid without end_time" do
    @work_session_time.end_time = nil
    @work_session_time.should_not be_valid
  end
 # it "should not be valid without user" do
 #   @work_session_time.user_id = nil
 #   @work_session_time.should_not be_valid
 # end
  
  
 
end
