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

class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => "User"
  validates :user, :friend, presence: true

  
  def self.create_reciproke_friendship(user1,user2)
    user1.friendships.create(:friend_id => user2.id)
    user1.inverse_friendships.create(:user_id => user2.id)
  end

  
end
