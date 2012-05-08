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
  
 
  
  context "attributes" do
    
    before(:each) { @friendship = FactoryGirl.build(:friendship)}
    
    it "should be valid with attributes from factory" do
       @friendship.should be_valid
    end
    
    it "should not be valid without an user" do
      @friendship.user = nil
      @friendship.should_not be_valid
    end
    
    it "should not be valid without a friend" do
      @friendship.friend = nil
      @friendship.should_not be_valid
    end
  end
  
  context "associations" do 
    
    before(:each) do
      @user = FactoryGirl.create(:user)
      @friend = FactoryGirl.create(:user)    
      @friendship = @user.friendships.create(:friend => @friend)
    end
    
    it "makes a friend accessible from a user" do
      @user.friends.first.should eq(@friend) 
    end
    
    it "does not make the user accessible from a friend" do
      @friend.friends.count.should eq(0)
    end   
    
    it "needs an inverse friendship to make the user accessible from a friend" do 
      @inverse_friendship = @user.inverse_friendships.create(:user => @friend)
      @friend.friends.first.should eq(@user) 
    end
    
  end
end


