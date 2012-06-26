# == Schema Information
#
# Table name: appointments
#
#  id            :integer         not null, primary key
#  sender_id     :integer
#  start_time    :datetime
#  end_time      :datetime
#  token         :string(255)
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#  send_count    :integer
#  receive_count :integer
#

require 'spec_helper'

describe Appointment do
  before(:each) do 
    @appointment = FactoryGirl.create(:appointment)  
  end
  
  
  context "when created" do
    
    it "should be valid with attributes from factory" do
      @appointment.should be_valid
    end
    
    it "should not be valid without a sender" do
      @appointment.sender_id = nil
      @appointment.should_not be_valid
    end 
    
    it "should initialize send_count and receive_count" do
      @appointment.send_count.should eq(0)
      @appointment.receive_count.should eq(0)
    end   
    
    it "should generate a token" do
      @appointment.token.should_not be_nil
    end
  end

end
