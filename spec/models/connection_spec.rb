# == Schema Information
#
# Table name: connections
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  start_time :datetime
#  end_time   :datetime
#

require 'spec_helper'

describe Connection do
  before(:each) do
    @connection = Connection.new
  end
  
  it "is not valid without user_id" do
    @connection.should_not be_valid
  end
  
  it "is valid with user_id and start_time " do
    u=User.new
    @connection.user=u
    @connection.start_time = DateTime.current    
    @connection.should be_valid
  end
  
  it "calculates a zero duration without an end time" do
    @connection.start_time = DateTime.current
    @connection.duration.should == 0
  end
  
  it "calculates a 5 min duration with an end time 5 min later " do
    @connection.start_time = DateTime.current
    @connection.end_time = @connection.start_time + 5.minutes
    @connection.duration.should == 5
  end

end
