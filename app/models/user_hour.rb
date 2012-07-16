# == Schema Information
#
# Table name: user_hours
#
#  id                      :integer         not null, primary key
#  user_id                 :integer
#  start_time              :datetime
#  group_hour_id           :integer
#  appointment_id          :integer
#  accepted_appointment_id :integer
#  login_time              :datetime
#  login_count             :integer
#  created_at              :datetime        not null
#  updated_at              :datetime        not null
#

class UserHour < ActiveRecord::Base
  validates  :user, :start_time, :appointment, :group_hour, :presence => true
  validate :only_one_per_hour_and_user
  validate :within_appointment


  validates_associated :group_hour  
  belongs_to :user
  belongs_to :group_hour, :dependent => :destroy
  belongs_to :appointment
  belongs_to :accepted_appointment, :class_name => 'Appointment'
  
  before_validation :get_group_hour

  def self.this_week
    where("start_time>?",DateTime.current-1.hour) 
  end
  
  def self.current
    c = DateTime.current
    this_hour = DateTime.new(c.year,c.month,c.day, c.hour)
    user_hour = where("start_time = ?", this_hour).limit(1)[0]
    if c.minute>=55 and user_hour.nil?
      this_hour+=1.hours
      where("start_time = ?", this_hour).limit(1)[0]
    else
      user_hour 
    end
  end
  

  
  def self.next
    where("start_time >= (?)", DateTime.current-55.minutes).
    order("start_time").limit(1)[0]   
  end
  

  def self.until_now
    c=DateTime.current
    where("start_time<?",c) 
  end

  def self.logged_in
    where("login_count>0") 
  end
  
  def self.not_logged_in
    where("login_count is ?",nil) 
  end  
  
  def store_login
    if !self.login_time
      self.login_time=DateTime.current
      self.login_count=0
    end
    self.login_count+=1
    self.save
  end

  
  private
  def get_group_hour
    if group_hour.nil?
      group_hour = create_group_hour(:start_time=>start_time, :tokbox_session_id=>"asdf") 
    end
  end

  
  def only_one_per_hour_and_user
    if !persisted?
      user_hours = UserHour.where("user_id = ? and start_time = ?", user_id, start_time)
      if user_hours.count>0
        raise "tried to create more then one user_hour per hour and user "
        errors.add(:start_time, "can't create more then one user_hour per hour")
      end    
    end
 end
 
 def within_appointment
   if self.appointment and self.start_time
     if self.start_time<self.appointment.start_time or self.start_time>=self.appointment.end_time
         raise "tried to create an user_hour outside the appointment"
         errors.add(:start_time, "can't create an user_hour outside the appointment")
       end    
     end
   end
end
