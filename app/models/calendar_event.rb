# == Schema Information
#
# Table name: calendar_events
#
#  id              :integer         not null, primary key
#  user_id         :integer
#  start_time      :datetime
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  work_session_id :integer
#

class CalendarEvent < ActiveRecord::Base
  validates  :start_time,:user_id,  :presence => true
  belongs_to :user
  belongs_to :work_session
  has_one :room, :through => :work_session
 
  scope :this_week,( lambda do 
    c = DateTime.current
    today = DateTime.new(c.year,c.month,c.day)
    where("calendar_events.start_time >= ?", today)
  end)
  
  scope :order_by_start_time, order("calendar_events.start_time ASC")
  
  scope :has_user_ids,( lambda do |user_ids|
    where("calendar_events.user_id in (?)",user_ids)
  end)
  
  scope :with_foreigners,( lambda do |user|
     friend_ids = user.friendships.map(&:friend).map(&:id)
     friend_and_own_ids = friend_ids + [user.id]
     select("calendar_events.id, calendar_events.start_time,calendar_events.user_id,calendar_events.work_session_id").
     joins("inner join calendar_events as foreigner_calendar_events on calendar_events.work_session_id=foreigner_calendar_events.work_session_id").
     where("calendar_events.user_id=? and foreigner_calendar_events.user_id not in (?)",user.id, friend_and_own_ids)
  end)
    
  scope :foreign_events,( lambda do |user|
     friend_ids = user.friendships.map(&:friend).map(&:id)
     friend_and_own_ids = friend_ids + [user.id]
     joins("inner join calendar_events as own_calendar_events on calendar_events.work_session_id=own_calendar_events.work_session_id").
     where("own_calendar_events.user_id=? and calendar_events.user_id not in (?)",user.id, friend_and_own_ids)
  end)
  
  def find_or_create_work_session!    
    if work_session = WorkSession.find_work_session(self.user,self.start_time)
      self.work_session = work_session
    else 
      self.work_session = self.build_work_session(:start_time=>self.start_time, :room => self.user.room)
    end
    self.save
    self.work_session
  end
  
end
