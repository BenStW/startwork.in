class WorkSessionsController < ApplicationController
  layout "video_layout"
  
  def show
    work_session = WorkSession.find(params[:id])
    min_diff = (DateTime.current - work_session.start_time.to_datetime()) * 24 * 60

    if !work_session.users.include?(current_user)
      render :text =>  t("work_sessions.show.wrong_user")
    elsif min_diff < -5
      render :text => t("work_sessions.show.too_early")
    elsif min_diff>60
      render :text => t("work_sessions.show.too_late")      
    else     
       @tokbox_session_id = work_session.room.tokbox_session_id
       @room_name = "#{work_session.room.user.name}'s room"
       @work_buddies = work_session.users - [current_user]
            
       @tokbox_token = TokboxApi.instance.generate_token @tokbox_session_id, current_user
       @tokbox_api_key = TokboxApi.instance.api_key
     end
  end

end
