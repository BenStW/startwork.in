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
