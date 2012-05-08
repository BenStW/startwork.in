class InterestedUserController < ApplicationController
# Controller   InterestedUserController is not needed anymore!
  
  
 # skip_before_filter :authenticate_user!  
 # def show
 # end
 # 
 # def create
 #  flash[:alert] = nil
 #  flash[:notice] = nil  
 #      
 #   email = params[:email]
 #   if email.nil?
 #     flash[:alert] = t "interested_user.create.email_not_valid", :email => email
 #   else      
 #     existing_email = InterestedUser.find_by_email(email)
 #     if existing_email
 #         flash[:alert] = t "interested_user.create.exists_already", :email => email
 #     else 
 #       user= InterestedUser.new(:email => email)   
 #       if user.save
 #         flash[:notice] = t "interested_user.create.success", :email => email
 #       else
 #        flash[:alert] = t "interested_user.create.email_not_valid", :email => email 
 #      end
 #     end
 #   end
 #
 #   render 'show'
 # end
end
