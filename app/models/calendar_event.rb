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
    where("calendar_events.start_time >= ?", DateTime.current-1.hour)
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
  
  def self.friends_of(user)
    #TODO: write test case
     friends = user.friends.map(&:id)
     self.has_user_ids(friends)
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
  
# def self.after_logging_day
#   change_date = DateTime.new(2012,6,24)  #(2012,6,16) 
#   where("start_time > ? and start_time< ?",change_date,DateTime.current)    
# end
  def self.logged_in
    where("login_count>0") #.after_logging_day
  end
  def self.not_logged_in
    where("login_count is ?",nil) #.after_logging_day
  end
  def self.not_logged_in_this_week
    this_week.not_logged_in #.after_logging_day
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
 
 def self.work_session_with(user)

 end
  
 def self.no_work_session_with(user)
   #TODO write test case
   where("NOT EXISTS(select * from calendar_events as other_calendar_events 
      where calendar_events.work_session_id=other_calendar_events.work_session_id and
     other_calendar_events.user_id=?)",user.id)
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
  
  def self.split_to_hourly_start_times(start_time, end_time)
     
      start_times = []
      if start_time>end_time
        logger.error "New event had start_time=#{start_time} > end_time=#{end_time}"
        start_time, end_time = end_time, start_time
      end
      if start_time.minute!=0 or end_time.minute!=0
        raise "Error: for creating a calendar event the minutes must be 0"
      end
      hours = (end_time - start_time)*24-1
      (0..hours).each do |hour|
          hourly_start_time = start_time+hour.hours      
          if hourly_start_time.hour == 23
            # FIXME: fix the JS frontend
            logger.error "Workaround: don't accept working hours of 21UTC (23Uhr)."
          else
            start_times << start_time+hour.hours
          end
      end
      start_times
  end  
  

  
  
end
