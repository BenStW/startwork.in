# == Schema Information
#
# Table name: friendships
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  friend_id  :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Friendship do
 
  before(:each) do
    user_ben = FactoryGirl.create(:user)
    user_steffi = FactoryGirl.create(:user)
    @friendship = user_ben.friendships.build(:friend_id => user_steffi.id)
  end  
    

  it "is valid with valid attributes" do
    @friendship.should be_valid
  end
  
  it "should not be valid without user" do
    @friendship.user_id = nil
    @friendship.should_not be_valid
  end
  
  it "should not be valid without friend" do
    @friendship.friend_id = nil
    @friendship.should_not be_valid
  end  
  
end
