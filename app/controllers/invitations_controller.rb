class InvitationsController < ApplicationController
  


  def create
    @invitation = Invitation.new(params[:invitation])
    @invitation.sender = current_user
    if @invitation.save
      InvitationMailer.invitation(@invitation).deliver
      flash[:notice] = t("invitations.create.invitation_sent")
    else
      flash[:alert] = t("invitations.create.invitation_not_sent") #"Invitation not sent"
    end
    redirect_to root_url
  end  
   
  
end

=begin
if email.nil?
  flash[:alert] = t "interested_user.create.email_not_valid", :email => email
else      
  existing_email = InterestedUser.find_by_email(email)
  if existing_email
      flash[:alert] = t "interested_user.create.exists_already", :email => email
  else 
    user= InterestedUser.new(:email => email)   
    if user.save
      flash[:notice] = t "interested_user.create.success", :email => email
    else
     flash[:alert] = t "interested_user.create.email_not_valid", :email => email 
   end
  end
end
=end