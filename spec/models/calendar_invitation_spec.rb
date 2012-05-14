# == Schema Information
#
# Table name: calendar_invitations
#
#  id         :integer         not null, primary key
#  sender_id  :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe CalendarInvitation do


  
  context "when created" do
    before(:each) do
      @calendar_invitation = FactoryGirl.create(:calendar_invitation)
    end
    
    it "should be valid with attributes from the factory" do
      @calendar_invitation.should be_valid
    end
    
    it "is not valid without a sender" do
      @calendar_invitation.sender = nil
      @calendar_invitation.should_not be_valid
    end
  end
  

    
end
