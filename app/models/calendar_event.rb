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
#  login_time      :datetime
#  login_count     :integer
#

class CalendarEvent < ActiveRecord::Base
  validates  :start_time, :user, :work_session, :presence => true
  belongs_to :user
  belongs_to :work_session, :dependent => :destroy #TODO: is it ok to destroy the worksession?
  has_one :room, :through => :work_session

  def self.this_week
    c = DateTime.current
    today = DateTime.new(c.year,c.month,c.day)
    where("calendar_events.start_time >= ?", today)
  end 
  
  def self.today
    c = DateTime.current
    today = DateTime.new(c.year,c.month,c.day)
    tomorrow = today + 1.day
    where("calendar_events.start_time >= ? and calendar_events.start_time < ?", today, tomorrow)
  end  
  
  def self.order_by_start_time
    order("calendar_events.start_time ASC")
  end
  
  def self.has_user_ids(user_ids)
    where("calendar_events.user_id in (?)",user_ids)
  end
  
  def self.next
    # end_time (=start_time+1.hour) should be less then current time
    where("calendar_events.start_time >= (?)", DateTime.current-55.minutes).
    order("calendar_events.start_time").limit(1)[0]   
  end
  
  def self.current
    c = DateTime.current
    this_hour = DateTime.new(c.year,c.month,c.day, c.hour)
    calendar_event = where("start_time = ?", this_hour).limit(1)[0]
    if c.minute>=55 and calendar_event.nil?
      this_hour+=1.hours
      where("start_time = ?", this_hour).limit(1)[0]
    else
      calendar_event 
    end
  end  
  
  def self.after_logging_day
    change_date = DateTime.new(2012,6,24)  #(2012,6,16) 
    where("start_time > ? and start_time< ?",change_date,DateTime.current)    
  end
  def self.logged_in
    where("login_count>0").after_logging_day
  end
  def self.not_logged_in
    where("login_count is ?",nil).after_logging_day
  end
  def self.not_logged_in_this_week
    this_week.not_logged_in.after_logging_day
  end
  
  def self.with_foreigners(user)
    friend_ids = user.friendships.map(&:friend).map(&:id)
    friend_and_own_ids = friend_ids + [user.id]
    select("calendar_events.id, calendar_events.start_time,calendar_events.user_id,calendar_events.work_session_id").
    joins("inner join calendar_events as foreigner_calendar_events on calendar_events.work_session_id=foreigner_calendar_events.work_session_id").
    where("calendar_events.user_id=? and foreigner_calendar_events.user_id not in (?)",user.id, friend_and_own_ids)    
  end
  
 def self.own_with_foreigners(user)
   friend_ids = user.friendships.map(&:friend).map(&:id)
   friend_and_own_ids = friend_ids + [user.id]
   select("calendar_events.id, calendar_events.start_time,calendar_events.user_id,calendar_events.work_session_id").
   joins("inner join calendar_events as foreigner_calendar_events on calendar_events.work_session_id=foreigner_calendar_events.work_session_id").
   where("calendar_events.user_id=? and foreigner_calendar_events.user_id not in (?)",user.id, friend_and_own_ids)    
 end
  
  def find_or_build_work_session
    self.work_session = WorkSession.find_work_session(self.user,self.start_time)  ||   
                        self.build_work_session(:start_time=>self.start_time, :room => self.user.room)
  end
  
  def store_login
    if !self.login_time
      self.login_time=DateTime.current
      self.login_count=0
    end
    self.login_count+=1
    self.save
  end
  
  def test_method
    @login_count
  end
  
  def as_json1(options)
    options = {  :only=>[:id,:start_time,:user_id], :include => {:user => {:only=>[:id,:fb_ui,:first_name,:last_name]}} }.merge(options)
    super(options)
  end
 
=begin
  scope :this_week_scope,( lambda do 
    c = DateTime.current
    today = DateTime.new(c.year,c.month,c.day)
    where("calendar_events.start_time >= ?", today)
  end)
  
  scope :next_scope, (lambda do 
    where("calendar_events.start_time >= (?)", DateTime.current).
    order("calendar_events.start_time").limit(1) 
  end)
  
  scope :order_by_start_time_scope, order("calendar_events.start_time ASC")
  
  scope :has_user_ids_scope,( lambda do |user_ids|
    where("calendar_events.user_id in (?)",user_ids)
  end)
  
  scope :with_foreigners_scope,( lambda do |user|
     friend_ids = user.friendships.map(&:friend).map(&:id)
     friend_and_own_ids = friend_ids + [user.id]
     select("calendar_events.id, calendar_events.start_time,calendar_events.user_id,calendar_events.work_session_id").
     joins("inner join calendar_events as foreigner_calendar_events on calendar_events.work_session_id=foreigner_calendar_events.work_session_id").
     where("calendar_events.user_id=? and foreigner_calendar_events.user_id not in (?)",user.id, friend_and_own_ids)
  end)
    
  scope :foreign_events_scope,( lambda do |user|
     friend_ids = user.friendships.map(&:friend).map(&:id)
     friend_and_own_ids = friend_ids + [user.id]
     joins("inner join calendar_events as own_calendar_events on calendar_events.work_session_id=own_calendar_events.work_session_id").
     where("own_calendar_events.user_id=? and calendar_events.user_id not in (?)",user.id, friend_and_own_ids)
  end)
=end
  

  
  
end
