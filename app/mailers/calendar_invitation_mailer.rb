class CalendarInvitationMailer < ActionMailer::Base
  default from: "admin@startwork.in" # Sender is defined in the environment files
  
  def calendar_invitation_email(work_sessions, sender, recipient)
    @work_sessions  = work_sessions
    @recipient = recipient
    @sender = sender
    mail(:to => recipient.email, :subject =>  t("mailers.calendar_invitation_mailer.subject", :sender_name=>@sender.name))
  end
  
end
