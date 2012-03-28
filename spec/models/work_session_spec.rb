# == Schema Information
#
# Table name: work_sessions
#
#  id         :integer         not null, primary key
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  start_time :datetime
#  room_id    :integer
#

require 'spec_helper'

describe WorkSession do
  before(:each) do
    @work_session = FactoryGirl.create(:work_session) 
  end
  
  it "is valid with attributes start_time and room" do
    @work_session.should be_valid
  end

  it "is not valid without start_time" do
    @work_session.start_time = nil
    @work_session.should_not be_valid
  end
  
  it "is not valid without a room " do
    @work_session.room_id = nil
    @work_session.should_not be_valid
  end  
  

end
