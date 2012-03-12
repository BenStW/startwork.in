class CalendarsController < ApplicationController
  def show
  end
  
  def new_time
    logger.info "create new time for #{params.to_yaml}"
    work_session = WorkSession.find(params[:work_session_id])
    start_time = DateTime.parse(params[:start_time])
    end_time = DateTime.parse(params[:end_time])    
    work_session.create_work_session_times(start_time,end_time)
    work_session.save
    render :json => "succussfully saved event"
  end

  def all_times
    logger.info "show all times for #{params.to_yaml}"   
    work_session = WorkSession.find(params[:work_session_id])    
    render :json => "succussfully communicated that all times are needed"
  end
end
