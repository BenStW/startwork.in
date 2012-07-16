class ErrorMailer < ActionMailer::Base
  default from: "benedikt@startwork.in" # Sender is defined in the environment files
  
  def deliver_exception(exception,current_user=nil)
    @exception = exception
    @current_user = current_user
    mail(:to => ["benedikt@startwork.in","miro@startwork.in", "robert@startwork.in"], :subject => "Error auf StartWork.in") 
  end 
end
