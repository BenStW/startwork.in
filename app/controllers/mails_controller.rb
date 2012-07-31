class MailsController < ApplicationController
  skip_before_filter :authenticate_user!

  def after_first_2_days_if_not_active
    users = User.after_first_2_days_if_not_active
   # users.each do |user|
   #   StartWorkMailer.after_first_2_days_if_not_active(user).deliver                    
   # end
    render :text => users.map(&:name) 
  end

end