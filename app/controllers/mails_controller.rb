class MailsController < ApplicationController
  skip_before_filter :authenticate_user!

  def index
    @after_first_2_days_if_not_active = User.after_first_2_days_if_not_active
  end
  
  def after_first_2_days_if_not_active
     users = User.after_first_2_days_if_not_active
     users.each do |user|
       StartWorkMailer.after_first_2_days_if_not_active(user).deliver                    
     end    
     redirect_to mails_url, :notice => "successfully sent the mails to #{users.map(&:name).join(',')}"
  end

end