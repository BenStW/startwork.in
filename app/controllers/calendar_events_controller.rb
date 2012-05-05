class CalendarEventsController < ApplicationController
  def show
     @friends = current_user.friendships.map(&:friend)
     @work_sessions = current_user.all_events_of_this_week.map(&:work_session).sort_by!{|w| w[:start_time]}     
  end
  
  # creates a calendar event and
  # finds or creates a work_session
  def new_event
    hourly_start_times = split_to_hourly_start_times(DateTime.parse(params[:start_time]),DateTime.parse(params[:end_time]))
    hourly_start_times.each do |start_time|
      if current_user.calendar_events.find_by_start_time(start_time)
        logger.error("ERROR: calendar event for user #{current_user.name} at #{start_time} does already exist.")
        #CalendarEvent.find_by_sql('select c1.id from calendar_events as c1 inner join calendar_events as c2 on c1.user_id=c2.user_id and c1.start_time=c2.start_time where c1.id<>c2.id')        
      else
        calendar_event = current_user.calendar_events.build(start_time: start_time)
        calendar_event.save
        calendar_event.find_or_create_work_session!
      end
    end
    render :json => "succussfully created event"
  end
  
  def events
    user_ids = params[:user_ids].split(',')
    #TODO: verify that current_user is allowed to access these calendar_events (this means, that they are his friends)
    render :json => CalendarEvent.this_week.has_user_ids(user_ids).to_json #(:include => {:user =>{ :only=>:id, :methods => :name}})
  end

   def remove_event
   calendar_event = current_user.calendar_events.find_by_id(params[:event])
   work_session = calendar_event.work_session
   calendar_event.delete
   if work_session.calendar_events.count == 0 
     work_session.delete
   elsif work_session.room.user == current_user     
     first_user = work_session.users.first
     work_session.room = first_user.room
     work_session.save
    end
    
    render :json => "succussfully removed time"
  end    


  
  private 
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
        hourly_start_time = start_time+hour.hours      
        if hourly_start_time.hour == 23
          logger.error "Workaround: don't accept working hours of 21UTC (23Uhr)."
        else
          start_times << start_time+hour.hours
        end
    end
    start_times
  end
  
end

