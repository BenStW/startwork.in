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
    where("work_sessions.start_time >= ?", today)
  end)
  
  scope :has_user_ids, (lambda do |user_ids|
     joins(:calendar_events).where("calendar_events.user_id in (?)", user_ids)
  end)
  
# scope :has_not_user_ids, (lambda do |user_ids|
#  #  select("work_sessions.*,calendar_events.*").
#    joins(:calendar_events).where("calendar_events.user_id not in (?)", user_ids)
# end)
  
  scope :only_friends, (lambda do |user|
    friend_ids = user.friendships.map(&:friend).map(&:id)
    has_user_ids(friend_ids)
  end)
  
#  scope :with_foreigners, (lambda do |user|
   # friend_ids = user.friendships.map(&:friend).map(&:id)
  #  friend_and_own_ids = friend_ids + [user.id]
#    has_not_user_ids(friend_and_own_ids)
#  end)
  
  scope :start_time, (lambda do |start_time|
    where("work_sessions.start_time = ?", start_time)
  end)
  
 scope :order_by_calendar_events_count,( lambda do 
   joins(:calendar_events).
   select("work_sessions.*,count(calendar_events.work_session_id) as calendar_events_count").
   group("work_sessions.id").
   order("calendar_events_count ASC")
 end)
 
 scope :events_count,( lambda do |count|
   joins(:calendar_events).
   group("work_sessions.id").
   having("count(calendar_events.work_session_id) = ?",count)
 end)
 
 
 def self.optimze_single_work_session(user)
   single_work_sessions = WorkSession.this_week.has_user_ids(user.id).events_count(1)
   single_work_sessions.each do |single_work_session|
     start_time = single_work_session.start_time
     opt_work_session = WorkSession.find_work_session(user,start_time)
     if opt_work_session != single_work_session
       calendar_event = single_work_session.calendar_events.first
       single_work_session.delete
       calendar_event.work_session = opt_work_session
     end
   end
  end
  
  def self.split_work_session_when_not_friend(user)
    work_sessions
  end
  
  
  def self.find_work_session(user, start_time)
    # Currently find the work session with the maximum friends
    work_session = WorkSession.start_time(start_time).only_friends(user).order_by_calendar_events_count.last
  end
end    
