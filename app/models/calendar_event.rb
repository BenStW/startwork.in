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
    where("start_time >= ?", today)
  end)
  
  scope :has_user_ids,( lambda do |user_ids|
    where("user_id in (?)",user_ids)
  end)

  
end
