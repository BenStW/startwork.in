class StartWorkMailer < ActionMailer::Base
  layout 'mail_layout'
  default from: "info@startwork.in" # Sender is defined in the environment files
  
  def after_registration(user)
    @user = user
    mail(:to => user.email, 
    :bcc => ["benedikt@startwork.in","miro@startwork.in", "robert@startwork.in"],
    :subject => "Willkommen auf StartWork!") 
  end 
  
  def after_creation_of_appointment(appointment)
    @user = appointment.user
    @appointment = appointment
    @users =  User.users_during_appointment(appointment)
    
   # [55,108,523,526,846].each do |user_id|
   #   if u=User.find_by_id(user_id)
   #     @users<<u
   #   end
   # end
   # @users = @users.uniq

    mail(:to => @user.email, 
    :bcc => ["benedikt@startwork.in","miro@startwork.in", "robert@startwork.in"],
    :subject => "Du bist verabredet!") 
  end  
  
  def after_first_2_days_if_not_active(user)
    @user = user
    mail(:to => user.email, 
    :bcc => ["benedikt@startwork.in","miro@startwork.in", "robert@startwork.in"],
    :subject => "Wie lief es beim letzten Mal ohne StartWork?")        
  end

end