class CalendarsController < ApplicationController
  def show
   @friends = current_user.friendships.map(&:friend)
#    @users = @friends.insert(0,current_user.name)
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

  def get_events
    return_hash = Hash.new  
    options_hash = Hash.new         
    events_array = events_to_array(current_user.all_events_of_this_week, 0)

    if params[:user_ids]
      users_array = [current_user.name]
      if params[:user_ids] == "all"
        users_array << "All"
        events_array += events_to_array(current_user.all_friends_events_of_this_week,1)
      else
        user_ids = params[:user_ids].split(',')
        friends =[]
        user_ids.each do |user_id|
          friends << current_user.friendships.where(:friend_id => user_id.to_i).first.friend
        end
        friends.each_with_index do |friend,index|
           users_array.push(friend.name)
           events = friend.all_events_of_this_week
           events_array += events_to_array(events,index+1) unless events.length==0
         end
      end
      options_hash[:users] = users_array
    else
      options_hash[:showAsSeparateUser] = false
      options_hash[:users] = []    
    end

    return_hash[:options] = options_hash
    return_hash[:events] = events_array
    render :json =>  return_hash.to_json  
  end
  
  def remove_event
    event = current_user.work_session_times.find_by_id(params[:event])
   # WorkSessionTime.find(params[:event])
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

