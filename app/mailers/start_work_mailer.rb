class StartWorkMailer < ActionMailer::Base
  default from: "info@startwork.in" # Sender is defined in the environment files
  
  def after_registration(user)
    @user = user
    mail(:to => ["benedikt@startwork.in"], 
    :bcc => ["benedikt@startwork.in","miro@startwork.in", "robert@startwork.in"],
    :subject => "Willkommen zu StartWork!") 
  end 

end
