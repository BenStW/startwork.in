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
    @user = FactoryGirl.create(:user)
    @room = @user.room      
  end
  
  context "attributes" do 
    it "should be valid with attributes of factory" do
       @room.should be_valid
    end   
  end


end


