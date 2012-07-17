class InfoMailer < ActionMailer::Base
  default from: "info@startwork.in" # Sender is defined in the environment files
  
  def deliver_new_user(user,current_user=nil)
    @user = user
    mail(:to => ["benedikt@startwork.in","miro@startwork.in", "robert@startwork.in"], :subject => "Neuer Nutzer: #{user.name}") 
  end 
  
  def deliver_session_start(user, group_hour)
    @user = user
    @group_hour = group_hour
    mail(:to => ["benedikt@startwork.in","miro@startwork.in", "robert@startwork.in"], :subject => "#{user.name} startet Session")     
  end
end
