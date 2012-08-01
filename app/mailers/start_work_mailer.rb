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
  
  def summary_for_next_day(user)
    @user = user
    @appointments = user.appointments.tomorrow
    mail(:to => user.email, 
    :bcc => ["benedikt@startwork.in","miro@startwork.in", "robert@startwork.in"],
    :subject => "Deine Arbeitszeiten morgen!")        
    
  end

end