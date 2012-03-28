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
    @room = FactoryGirl.build(:room)
  end
  
  it "creates a tokbox_session_id when asked if valid" do
    @room.tokbox_session_id.should be_nil    
    @room.should be_valid
    @room.tokbox_session_id.should_not be_nil
  end
end


