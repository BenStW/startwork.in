# == Schema Information
#
# Table name: work_sessions
#
#  id         :integer         not null, primary key
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  start_time :datetime
#  room_id    :integer
#

class WorkSession < ActiveRecord::Base
  validates :start_time, :room_id, :presence => true
  has_many :calendar_events
  has_many :users, :through=> :calendar_events  
  belongs_to :room 
  
  scope :this_week,( lambda do 
    c = DateTime.current
    today = DateTime.new(c.year,c.month,c.day)
    where("start_time >= ?", today)
  end)
  
  scope :has_user_ids, (lambda do |user_ids|
    joins(:room).where("user_id in (?)", user_ids)
  end)
  
  scope :start_time, (lambda do |start_time|
    where("start_time = ?", start_time)
  end)
  
  def self.find_existing_work_session(user, start_time)
    friend_ids = user.friendships.map(&:friend).map(&:id)
    work_sessions = WorkSession.start_time(start_time).has_user_ids(friend_ids)
    if work_sessions.count == 0      
      nil
    else
      work_sessions.first
    end
  end
end    
