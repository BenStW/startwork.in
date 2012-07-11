# == Schema Information
#
# Table name: appointments
#
#  id            :integer         not null, primary key
#  start_time    :datetime
#  end_time      :datetime
#  token         :string(255)
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#  send_count    :integer
#  receive_count :integer
#  user_id       :integer
#

class Appointment < ActiveRecord::Base
  belongs_to :user
  has_many :user_hours, :dependent => :destroy 
  
  validates :user, :start_time, :end_time, presence: true
  validate :start_time_lt_end_time
  validate :appointment_does_not_overlap
    
  before_create :generate_token 
     
  after_save :update_user_hours 

  after_initialize :init
  
  attr_accessor :accepted_appointment
  
  def init
    self.send_count ||= 0
    self.receive_count ||= 0
    self.accepted_appointment ||= nil
  end  
  
  def generate_token
   self.token = Digest::SHA1.hexdigest([Time.now, rand].join)
  end
  
  def self.split_to_hourly_start_times(start_time, end_time)  
      start_time = start_time.to_datetime
      end_time = end_time.to_datetime   
      start_times = []
      
      if start_time>end_time
        raise "Error: New appointment had start_time=#{start_time} > end_time=#{end_time}"
      end
      
      if start_time.minute!=0 or end_time.minute!=0
        raise "Error: New appointment had minutes<>0"
      end
      
      if start_time.to_date != end_time.to_date
        raise "Error: New appointment had different start and end days"
      end
      
      hours = (end_time - start_time)*24 - 1
      (0..hours).each do |hour|
          hourly_start_time = start_time+hour.hours      
          start_times << start_time+hour.hours
      end
      start_times
  end  
  
  def user_hour(start_time)
    user_hours.find_by_start_time(start_time)    
  end
  
  def group_hour(start_time)
      user_hour(start_time).group_hour
  end 
  
  def overlap?(start_time, end_time)
    if user.nil?
      raise "user is nil. Can't test whether appointments overlap"
    end
    overlapping_appointments = user.appointments.where("(appointments.start_time<? and appointments.end_time>?) or 
         appointments.start_time<? and appointments.end_time>?",start_time,start_time,end_time,end_time)
    !overlapping_appointments.empty?
  end
  
  
  def self.can_create_new_appointment?(user, start_time, end_time)
    user_hours = user.user_hours.where("user_hours.start_time>=? and user_hours.start_time < ?", start_time, end_time)
    user_hours.empty?
  end
  
  
  
  def self.accept_received_appointment(recipient, appointment)
    
    if !recipient.received_appointments.include?(appointment)
      raise "can't accept appointment when it is not stored as received"
    end
    if recipient == appointment.user
      raise "a user can't accept his own appointments"      
    end
    start_time = appointment.start_time
    end_time = appointment.end_time
    
    if Appointment.can_create_new_appointment?(recipient, start_time, end_time)    
      new_appointment = user.appointments.build(
         :start_time=>start_time, :end_time=>end_time)
      
      new_appointment.accepted_appointment = appointment #this is used in the after_save callback
      new_appointment.save
      new_appointment
    else
      nil
    end
  end  
  
  def update_user_hours
    delete_not_needed_user_hours
    
    add_user_hours_based_on_accepted_appointment
    
    start_times = Appointment.split_to_hourly_start_times(start_time, end_time)
    
    start_times.each do |s|
      if !self.user_hours.find_by_start_time(s)
         u = self.user_hours.create(:user => self.user, :start_time=>s)
      end
    end
  end  
  
  private 
  def start_time_lt_end_time
    if !start_time.nil? and !end_time.nil? and start_time >= end_time
      errors.add(:start_time, "start_time (#{start_time}) must be lower then end_time (#{end_time})")
    end      
  end
  
  def appointment_does_not_overlap
    if overlap?(start_time, end_time)
      errors.add(:start_time, "When creating a new Appointment, it must not overlap with an existing one.")
    end
  end
  
  def delete_not_needed_user_hours
    self.user_hours.each do |user_hour|
      if user_hour.start_time<self.start_time or user_hour.start_time>=self.end_time
        user_hour.delete
      end
    end    
  end
  
  def add_user_hours_based_on_accepted_appointment
    if self.accepted_appointment
      s = self.accepted_appointment.start_time
      e = self.accepted_appointment.end_time
      start_times = Appointment.split_to_hourly_start_times(s,e)
      start_times.each do |s|
        # user_hours can't exist currently
        u = self.user_hours.create(
          :user => self.user,
          :start_time=>s,
          :accepted_appointment=>self.appointment,
          :group_hour=>self.appointment.group_hour(s))
      end
      self.accepted_appointment = nil
    end
    
  end
  

  

end
