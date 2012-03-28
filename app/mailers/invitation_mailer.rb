class InvitationMailer < ActionMailer::Base
  default from: "benedikt@startwork.in" # Sender is defined in the environment files
  
  def invitation(invitation)
    @recipient = invitation.recipient_mail
    @sender_name = invitation.sender.name
    @sender_mail = invitation.sender.email
    mail(:to => @recipient, :subject => t("mailers.invitation_mail.subject", :sender_name =>@sender_name) ) 
  end

  
end
