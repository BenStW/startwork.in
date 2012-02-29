# == Schema Information
#
# Table name: penalties
#
#  id           :integer         not null, primary key
#  from_user_id :integer
#  to_user_id   :integer
#  excuse       :string(255)
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#  start_time   :datetime
#  end_time     :datetime
#

class Penalty < ActiveRecord::Base
  belongs_to :to_user, :class_name => "User"
  belongs_to :from_user, :class_name => "User"
  
 def old_open?
    !current_work_hour? and end_time.nil?
 end
 
 def current_work_hour?
   c = DateTime.current
   c.year == start_time.year and c.month == start_time.month and c.hour == start_time.hour
 end
 
 def close
  s = start_time
  self.end_time = DateTime.new(s.year, s.month, s.day, s.hour, 49, 59 )
  logger.info("Close the old and open penalty #{id}")
 end
  
end
