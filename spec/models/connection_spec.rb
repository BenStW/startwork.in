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
  
  before(:each) { @connection = FactoryGirl.build(:connection) }

  context "attributes" do
    
    it "is valid with attributes from factory" do
      @connection.should be_valid
    end
    
    it "is not valid without a user" do
      @connection.user = nil
      @connection.should_not be_valid
    end
    
    it "is not valid without a start_time" do
      @connection.start_time = nil
      @connection.should_not be_valid
    end
    
  end
  
  context "methods" do
    
    it "calculates a zero duration without an end time" do
      @connection.duration.should eq(0)
    end

    it "calculates a 5 min duration with an end time 5 min later " do
      @connection.end_time = @connection.start_time + 5.minutes
      @connection.duration.should eq(5)
    end
        
  end
  


end
