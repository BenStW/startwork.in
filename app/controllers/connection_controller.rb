class ConnectionController < ApplicationController
  def end
    for user_id in params[:user_ids]
       @user = User.find(user_id)
       @user.end_connection
    end
    render :json => "hello"
  end
end
