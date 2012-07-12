# == Schema Information
#
# Table name: received_appointments
#
#  id             :integer         not null, primary key
#  user_id        :integer
#  appointment_id :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

class RecipientAppointment < ActiveRecord::Base
  belongs_to :user
  belongs_to :appointment
  has_one :sender, :through=> :appointment, :source => :user 

  validates :user, :appointment, presence: true
  validate :is_not_own_appointment
  
  #get UserHours by a class method
  
  def group_hour(start_time)
    user_hour_of_sender =  appointment.user_hours.find_by_start_time(start_time)
    if user_hour_of_sender
      user_hour_of_sender.group_hour
    else
      raise "the appointment #{appointment.id} doesnt't have a user_hour at #{start_time}"
    end
  end
  
  private
  
  def is_not_own_appointment
    if self.user and self.appointment and self.user == appointment.user
      errors.add(:user, "can't send the appointment to the same user")
    end    
    
  end
  
end
