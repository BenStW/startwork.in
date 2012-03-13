class CalendarsController < ApplicationController
  def show
  end
  
  def new_event
    work_session = WorkSession.find(params[:work_session_id])
    logger.info "create new start_time #{params[:start_time]} - #{params[:start_time].class}"
    start_time = DateTime.parse(params[:start_time])
    end_time = DateTime.parse(params[:end_time])  

    work_session.work_session_times.create(start_time:start_time,end_time:end_time)
    render :json => "succussfully created event"
  end

  def all_events
    work_session = WorkSession.find(params[:work_session_id])  
    events = work_session.all_events_of_this_week
    events_array = Array.new
    for event in events
      t_hash = Hash.new
      t_hash[:id] = event.id 
      logger.info "send back start_time #{event.start_time}"
      t_hash[:start] = event.start_time
      t_hash[:end] = event.end_time
      t_hash[:title] = ""    
      events_array.push(t_hash)
    end
    render :json =>  events_array.to_json  
  end
  
  def remove_event
    work_session = WorkSession.find(params[:work_session_id])
    event = WorkSessionTime.find(params[:event])
    event.delete
    render :json => "succussfully removed time"
  end    
  
  
end

