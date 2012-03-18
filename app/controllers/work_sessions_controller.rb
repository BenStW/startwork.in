class WorkSessionsController < ApplicationController
  layout "video_layout"
  def show
    @work_session = WorkSession.find(params[:id])

    
    #TODO check whether user was planned to join this work_session
    connection_data = { :user_id => "#{current_user.id}", :user_name => "#{current_user.name}" } 
    @tokbox_token = TokboxApi.instance.generate_token @work_session.tokbox_session_id, connection_data
    @tokbox_api_key = TokboxApi.instance.api_key
  end
end
