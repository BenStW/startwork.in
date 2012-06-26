class CalendarEventsController < ApplicationController
  
  def show
     @friends = current_user.friends #current_user.friendships.map(&:friend)
     @work_sessions = current_user.calendar_events.this_week.map(&:work_session).sort_by!{|w| w[:start_time]}    
     #TODO this is hack
     @app = if Rails.env.production? then "330646523672055" else "232041530243765" end
      
  end
  
  # creates a calendar event and
  # finds or creates a work_session
  def new_event
    hourly_start_times = CalendarEvent.split_to_hourly_start_times(DateTime.parse(params[:start_time]),DateTime.parse(params[:end_time]))
    hourly_start_times.each do |start_time|
      if current_user.calendar_events.find_by_start_time(start_time)
        logger.error("ERROR: calendar event for user #{current_user.name} at #{start_time} does already exist.")
        #CalendarEvent.find_by_sql('select c1.id from calendar_events as c1 inner join calendar_events as c2 on c1.user_id=c2.user_id and c1.start_time=c2.start_time where c1.id<>c2.id')        
      else
        calendar_event = current_user.calendar_events.build(start_time: start_time)
        calendar_event.find_or_build_work_session
        calendar_event.save
      end
    end
    render :json => "succussfully created event"
  end
  
  
  def events
  # render :json => CalendarEvent.this_week.to_json(
  #   :only=>[:id,:start_time,:user_id],:methods=>:test_method, :include => {:user => {:only=>[:id,:fb_ui,:first_name,:last_name], :methods => :is_friend_of_current_user?}} )

   @calendar_events = CalendarEvent.this_week
  end

   def remove_event
   calendar_event = current_user.calendar_events.find_by_id(params[:event])
   if calendar_event.nil?
     raise "Calendar event #{params[:event]} does not belong to user #{current_user.name}. Dump of the event: #{CalendarEvent.find(params[:event]).to_yaml}"
   end
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
  
  
  def send_invitation
    calendar_invitation = CalendarInvitation.new(:sender_id=>current_user.id)      
    calendar_invitation.save      
    
    work_sessions = WorkSession.single_work_sessions_with_user_id(current_user.id)
    if !work_sessions.empty?    
       User.all.each do |user|
         if current_user != user
           email = CalendarInvitationMailer.calendar_invitation_email(work_sessions, current_user, user)
           email.deliver
         end
       end  
    render :json => "succussfully sent invitation"
  else
    render :json => "no single worksessions"
  end
  end  
  

  
end

