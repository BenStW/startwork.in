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
  
  after_create :update_work_sessions_after_create
  before_destroy :update_work_sessions_after_destroy
  
  def update_work_sessions_after_create
  #  WorkSession.optimize_single_work_session(user)
   # WorkSession.optimize_single_work_session(friend)
  end
  
  def update_work_sessions_after_destroy
  #  WorkSession.split_work_session_when_not_friend(user)
  #  WorkSession.split_work_session_when_not_friend(friend)
  end
  
end
