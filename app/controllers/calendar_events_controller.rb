class CalendarEventsController < ApplicationController
  def show
     @friends = current_user.friendships.map(&:friend)
   #  puts @friends.to_yaml
     @work_sessions = current_user.all_events_of_this_week.map(&:work_session).sort_by!{|w| w[:start_time]}     
   #  puts @work_sessions.to_yaml
  end
  
  # creates a calendar event and
  # finds or creates a work_session
  def new_event
    hourly_start_times = split_to_hourly_start_times(DateTime.parse(params[:start_time]),DateTime.parse(params[:end_time]))
    hourly_start_times.each do |start_time|
      calendar_event = current_user.calendar_events.build(start_time: start_time)
      calendar_event.save
      calendar_event.find_or_create_work_session!
    end
    render :json => "succussfully created event"
  end

  def get_events
    return_hash = Hash.new  
    options_hash = Hash.new         
    events_array = events_to_array(current_user.all_events_of_this_week, 0)

    if params[:user_ids]
      users_array = [current_user.name]
      if params[:user_ids] == "all"
        users_array << t("calendar_events.show.all")
        events = current_user.all_friends_events_of_this_week
        events_array += events_to_array(events,1) unless events.length==0
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
    calendar_event = current_user.calendar_events.find_by_id(params[:event])
   work_session = calendar_event.work_session
   if work_session.calendar_events.count == 1
     work_session.delete
   end
    calendar_event.delete
    render :json => "succussfully removed time"
  end    
  
  private 
  def events_to_array(events, user_id)
    events_array = Array.new
    for event in events  
      e = Hash.new
      e[:id] = event.id 
      e[:start] = event.start_time
      e[:end] = event.start_time+1.hour
      e[:userId] = user_id
      events_array.push(e)      
    end
    events_array
  end  
  
  def split_to_hourly_start_times(start_time, end_time)
    start_times = []
    if start_time>end_time
      logger.error "New event had start_time=#{start_time} > end_time=#{end_time}"
      e = end_time
      end_time = start_time
      start_time = e
    end
    hours = (end_time - start_time)*24-1
    (0..hours).each do |hour|
      start_times << start_time+hour.hours
    end
    start_times
  end
  
end

