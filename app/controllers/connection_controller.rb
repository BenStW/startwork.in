class ConnectionController < ApplicationController
  def end
    
    for user_id in params[:user_ids]
       @user = User.find(user_id)
       @user.end_connection
    end
    render :json => "succussfully ended connection"
  end
  
  def start
    for user_id in params[:user_ids]
       @user = User.find(user_id)
       @user.start_connection
    end
    render :json => "succussfully started connection"
  end    
end
