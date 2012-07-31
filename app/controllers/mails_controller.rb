class MailsController < ApplicationController
  skip_before_filter :authenticate_user!

  def index
    @after_first_2_days_if_not_active = User.after_first_2_days_if_not_active
    
    @summary_for_next_day = Appointment.includes(:user).tomorrow.map(&:user).uniq
  end
  
  def after_first_2_days_if_not_active
     users = User.after_first_2_days_if_not_active
     users.each do |user|
       StartWorkMailer.after_first_2_days_if_not_active(user).deliver                    
     end    
     redirect_to mails_url, :notice => "successfully sent the mails to #{users.map(&:name).join(',')}"
  end
  
  def summary_for_next_day
    recipients = Appointment.includes(:user).tomorrow.map(&:user).uniq
    recipients.each do |user|
      StartWorkMailer.summary_for_next_day(user).deliver                    
    end
    redirect_to mails_url, :notice => "successfully sent the mails to #{recipients.map(&:name).join(',')}"
  end


end