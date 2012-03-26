class InvitationMailer < ActionMailer::Base
  default from: "benedikt@startwork.in"
  
  def invitation(invitation)
    @recipient = invitation.recipient_mail
    @sender_name = invitation.sender.name
    @sender_mail = invitation.sender.email
    mail(:to => @recipient, :subject => "Einladung von #{@sender_name}")
  end

  
end
