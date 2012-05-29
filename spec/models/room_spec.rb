# == Schema Information
#
# Table name: rooms
#
#  id                :integer         not null, primary key
#  user_id           :integer
#  tokbox_session_id :string(255)
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#

require 'spec_helper'

describe Room do
  before(:each) do
#    TokboxApi.stub_chain(:instance, :generate_session).and_return("tokbox_session_id")  
    @user = FactoryGirl.create(:user)
    @room = @user.room      
  end
  
  context "attributes" do 
    it "should be valid with attributes of factory" do
       @room.should be_valid
    end
    
    it "should populate tokbox_session_id when validating" do
      @room.tokbox_session_id = nil
      @room.should be_valid  
      @room.tokbox_session_id.should_not be_nil 
    end
  end
  
  context "methods" do
    it "should populate tokbox_session_id when not populated yet" do      
      @room.tokbox_session_id = nil
      @room.populate_tokbox_session
      @room.tokbox_session_id.should_not be_nil
      @room.should be_valid
    end
    
    it "should not populate tokbox_session_id when already populated" do
      tokbox_session_id = @room.tokbox_session_id
      @room.populate_tokbox_session
      @room.tokbox_session_id.should eq(tokbox_session_id)
      @room.should be_valid
    end    
  end

end


