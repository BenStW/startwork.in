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
    @room = FactoryGirl.create(:room)
  end
  
  it "is valid with a tokbox_session_id" do
    @room.should be_valid
  end

end


