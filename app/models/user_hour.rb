# == Schema Information
#
# Table name: user_hours
#
#  id                      :integer         not null, primary key
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
  validates_associated :group_hour  
  belongs_to :user
  belongs_to :group_hour, :dependent => :destroy
  belongs_to :appointment
  belongs_to :accepted_appointment, :class_name => 'Appointment'
  
  before_validation :get_group_hour

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
end
