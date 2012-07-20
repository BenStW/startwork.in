class StartWorkMailer < ActionMailer::Base
  default from: "info@startwork.in" # Sender is defined in the environment files
  
  def after_registration(user)
    @user = user
    mail(:to => [user.email], 
    :bcc => ["benedikt@startwork.in","miro@startwork.in", "robert@startwork.in"],
    :subject => "Willkommen auf StartWork!") 
  end 

end
