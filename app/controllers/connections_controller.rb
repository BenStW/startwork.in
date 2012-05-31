class ConnectionsController < ApplicationController
  
  def start
    logger.info "start connections of user_ids #{params[:user_ids].to_yaml}"
    for user_id in params[:user_ids]
      if user_id.to_i >1
         @user = User.find(user_id)
         @user.start_connection
      end
    end
    render :json => "succussfully started connection"
  end
  
  
  def end    
    for user_id in params[:user_ids]
      if user_id.to_i >1      
        @user = User.find(user_id)
        @user.end_connection
     end
    end
    render :json => "succussfully ended connection"
  end
  
 
end
