class WorkSessionsController < ApplicationController
  skip_before_filter :authenticate, :only => :test
  layout "video_layout"
  
  def show
    work_session = WorkSession.find(params[:id])
    if work_session.users.include?(current_user)
       @tokbox_session_id = work_session.room.tokbox_session_id
       @room_name = "#{work_session.room.user.name}' room"
       @work_buddies = work_session.users - [current_user]
       
       connection_data = { :user_id => "#{current_user.id}", :user_name => "#{current_user.name}" } 
       @tokbox_token = TokboxApi.instance.generate_token @tokbox_session_id, connection_data
       @tokbox_api_key = TokboxApi.instance.api_key
     else
      redirect_to root_url , :alert => t("work_sessions.show.wrong_user")
     end
  end
  
  
  def test
    if params[:username]
      user = User.find_by_name(params[:username])
      if !user
         redirect_to root_url , :alert => t("work_sessions.show.wrong_user")  
      else
        work_session = user.calendar_events.order(:start_time).first.work_session
        @tokbox_session_id = work_session.room.tokbox_session_id
        @room_name = "#{work_session.room.user.name}' room"
        @work_buddies = work_session.users - [current_user]
        
        connection_data = { :user_id => "#{current_user.id}", :user_name => "#{current_user.name}" } 
        @tokbox_token = TokboxApi.instance.generate_token @tokbox_session_id, connection_data
        @tokbox_api_key = TokboxApi.instance.api_key
        render 'show'
      end
    end
  end
end
