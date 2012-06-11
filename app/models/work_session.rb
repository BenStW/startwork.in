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
  validates :start_time, :room, :presence => true
  has_many :calendar_events
  has_many :users, :through=> :calendar_events  
  belongs_to :room
  before_destroy :remove_users_from_worksession
  belongs_to :guest, :class_name => "User"
  
  def self.this_week
    c = DateTime.current
    today = DateTime.new(c.year,c.month,c.day)
    where("work_sessions.start_time >= ?", today)
  end
  
  def self.start_time(start_time)
    where("work_sessions.start_time = ?", start_time)
  end
  
  def self.has_user_ids(user_ids)
     joins(:calendar_events).where("calendar_events.user_id in (?)", user_ids)
  end
  
  def self.with_friends(user)
#    friend_ids = user.friendships.map(&:friend).map(&:id)
    friend_ids = user.friends.map(&:id)
    has_user_ids(friend_ids)
  end
   
  def self.order_by_calendar_events_count 
    joins(:calendar_events).
    select("work_sessions.id, work_sessions.start_time").
    group("work_sessions.id, work_sessions.start_time").  
    order("count(calendar_events.work_session_id)")
  end
  
  #Don't combine this query with has_user_ids, because it breaks the query
  def self.events_count(count)
    joins(:calendar_events).
    select("work_sessions.id, work_sessions.start_time").
    group("work_sessions.id, work_sessions.start_time").  
    having("count(calendar_events.work_session_id) = ?",count)
  end
  
  
  def self.events_count_with_user_ids(user_ids)
    #FIXME: add this_week
    WorkSession.find_by_sql(
      ["select distinct ce_count_table.work_session_id, start_time,events_count from
      (SELECT work_session_id,count(work_session_id) as events_count from calendar_events
      GROUP BY work_session_id) as ce_count_table left join
      calendar_events
      on ce_count_table.work_session_id=calendar_events.work_session_id
      where user_id in (?)", user_ids])
  end  
  
  def self.single_work_sessions_with_user_id(user_id)
    c = DateTime.current
    today = DateTime.new(c.year,c.month,c.day)
    WorkSession.find_by_sql(
      ["select distinct ce_count_table.work_session_id, start_time from
      (SELECT work_session_id,count(work_session_id) as events_count from calendar_events
      GROUP BY work_session_id) as ce_count_table left join
      calendar_events
      on ce_count_table.work_session_id=calendar_events.work_session_id
      where events_count=1 and user_id in (?) and start_time >= ?
      order by start_time ASC", user_id, today])
  end  
  
 # def self.events_count_with_user_ids(count,user_ids)
 #   WorkSession.find_by_sql(
 #     ["select distinct ce_count_table.work_session_id, start_time,events_count from
 #     (SELECT work_session_id,count(work_session_id) as events_count from calendar_events
 #     GROUP BY work_session_id) as ce_count_table left join
 #     calendar_events
 #     on ce_count_table.work_session_id=calendar_events.work_session_id
 #     where events_count = ?
 #     and user_id in (?)", count, user_ids])
 # end
 #  
 
   def self.current
     c = DateTime.current
     this_hour = DateTime.new(c.year,c.month,c.day, c.hour)          
     where("work_sessions.start_time = ?", this_hour)
   end
   
   def self.free_for_guest(user)
     where("guest_id = ? or guest_id is null", user.id)
   end

   
   def self.assign_for_guest(user)
     work_session = WorkSession.current.free_for_guest(user).first
     if !work_session.nil? and work_session.guest_id.nil?
       work_session.guest_id = user.id
       work_session.save
     end
     work_session     
   end
 
   def self.split_work_session_when_not_friend(user)
     events_with_foreigners = CalendarEvent.this_week.with_foreigners(user)
     events_with_foreigners.each do |event|
       if !user.friends.include?(event.room.user)
         # foreign room
         logger.info "event #{event.id} starting at #{event.start_time} must get a new WorkSession"
         event.find_or_build_work_session
         event.save
       end
     end
   end
    
   def optimize_single_work_session(user)
     opt_work_session = WorkSession.find_work_session(user,start_time)
     if !opt_work_session.nil?
       puts "opt_work_session = #{opt_work_session.id}"
     else
       puts "opt_work_session = nil"
     end
     puts "self = #{self.id}"
     if opt_work_session != self and !opt_work_session.nil?
       if self.calendar_events.count != 1
         raise "Error: single work_session has more events!"
       end
       calendar_event = calendar_events.first
       calendar_event.work_session = opt_work_session
   
       calendar_event.save
       self.delete       
     end     
   end 
   
   def self.optimize_single_work_sessions(user)
     #FIXME: not only single work sessions are found
     single_work_sessions = WorkSession.this_week.has_user_ids(user.id).events_count(1)
     single_work_sessions.each do |single_work_session|
       single_work_session.optimize_single_work_session(user)
     end
   end
   
   def self.find_work_session(user, start_time)
     # Currently find the work session with the maximum friends
     # it finds also work sessions with foreigners, connected over a friend
     work_session = WorkSession.start_time(start_time).with_friends(user).order_by_calendar_events_count.last
     if work_session.nil?
       work_session = WorkSession.start_time(start_time).order_by_calendar_events_count.last
     end
     work_session
   end
   
   def remove_users_from_worksession
     #TODO
   end
    
   

  
  
=begin
 scope :this_week,( lambda do 
   c = DateTime.current
   today = DateTime.new(c.year,c.month,c.day)
   where("work_sessions.start_time >= ?", today)
 end)
 
 scope :has_user_ids, (lambda do |user_ids|
    joins(:calendar_events).where("calendar_events.user_id in (?)", user_ids)
 end)
 
 scope :only_friends, (lambda do |user|
   friend_ids = user.friendships.map(&:friend).map(&:id)
   has_user_ids(friend_ids)
 end)
 
 scope :start_time, (lambda do |start_time|
   where("work_sessions.start_time = ?", start_time)
 end)
 
 
scope :order_by_calendar_events_count,( lambda do 
  joins(:calendar_events).
  select("work_sessions.id, work_sessions.start_time").
  group("work_sessions.id, work_sessions.start_time").  #group("work_sessions.id").
  order("count(calendar_events.work_session_id)")
end)

scope :events_count,( lambda do |count|
  joins(:calendar_events).
  select("work_sessions.id, work_sessions.start_time").
  group("work_sessions.id, work_sessions.start_time").  #group("work_sessions.id").
  having("count(calendar_events.work_session_id) = ?",count)
end)
=end
end    
