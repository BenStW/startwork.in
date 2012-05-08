class WorkSessionsController < ApplicationController
  layout "video_layout"
  
  def show
    work_session = WorkSession.find(params[:id])
    if work_session.users.include?(current_user)
       @tokbox_session_id = work_session.room.tokbox_session_id
       @room_name = "#{work_session.room.user.name}'s room"
       @work_buddies = work_session.users - [current_user]
            
       @tokbox_token = TokboxApi.instance.generate_token @tokbox_session_id, current_user
       @tokbox_api_key = TokboxApi.instance.api_key
     else
      redirect_to root_url , :alert => t("work_sessions.show.wrong_user")
     end
  end

end
