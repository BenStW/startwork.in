class CalendarsController < ApplicationController
  def show
    
    friends = current_user.friendships.map(&:friend).map(&:name)
    @users = friends.insert(0,current_user.name)
  end
  
  def new_event
    logger.info "create new start_time #{params[:start_time]} - #{params[:start_time].class}"
    start_time = DateTime.parse(params[:start_time])
    end_time = DateTime.parse(params[:end_time])  
    if start_time>end_time
      logger.error "New event had start_time=#{start_time} > end_time=#{end_time}"
      render :json => "not created"
    else
      current_user.work_session_times.create(start_time:start_time,end_time:end_time)
     render :json => "succussfully created event"
    end
  end

  def all_events
     my_events = current_user.all_events_of_this_week
     events_array = events_to_array(my_events, 0)

    friends = current_user.friendships.map(&:friend)
    friends.each_with_index do |friend,index|
      events = friend.all_events_of_this_week
      events_array += events_to_array(events,index+1) unless events.length==0
    end
    render :json =>  events_array.to_json  
  end
  
  def remove_event
    event = WorkSessionTime.find(params[:event])
    event.delete
    render :json => "succussfully removed time"
  end    
  
  private 
  def events_to_array(events, user_id)
    events_array = Array.new
    for event in events  
      e = Hash.new
      e[:id] = event.id 
      e[:start] = event.start_time
      e[:end] = event.end_time
      e[:userId] = user_id
      events_array.push(e)      
    end
    events_array
  end  
end

