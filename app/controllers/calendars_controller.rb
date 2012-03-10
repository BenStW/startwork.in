class CalendarsController < ApplicationController
  def show
  end
  
  def event_new
    logger.info "create new event for #{params.to_yaml}"
    work_session = WorkSession.find(params[:work_session_id])
    logger.info "start_time = #{params[:start_time]}"
    work_session_time = work_session.work_session_times.create(start_time: params[:start_time])  
    
    render :json => "succussfully communicated event"
  end
end
