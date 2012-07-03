class AppointmentsController < ApplicationController
  skip_before_filter :authenticate_user!,  :only => [:show,:reject,:accept_without_authentication]
  
  def get_token
     start_time = params["start_time"]
     end_time = params["end_time"]
     appointment = current_user.appointments.create(:start_time=>start_time, :end_time=>end_time)
     render :json => appointment.token
   end
   
  def show
     token = params["token"]
     @appointment = Appointment.find_by_token(token)
     if @appointment.nil?
       render :json => "keine Verabredung gefunden"
     end    
  end
  
  def reject
     redirect_to root_url
  end  
  
  def accept_without_authentication
    session[:appointment_token] = params["token"]
    redirect_to appointment_accept_url
  end
  
  def accept
    token = session[:appointment_token]
    session[:appointment_token]= nil  
    appointment = Appointment.find_by_token(token)    
    if appointment.nil?
      render :json => "keine Verabredung gefunden"
    else
       appointment.receive_count+=1
       appointment.save
       
       hourly_start_times = CalendarEvent.split_to_hourly_start_times(appointment.start_time.to_datetime,appointment.end_time.to_datetime)
       hourly_start_times.each do |start_time|
         if current_user.calendar_events.find_by_start_time(start_time)
           logger.error("ERROR: calendar event for user #{current_user.name} at #{start_time} does already exist.")
         else
           calendar_event = current_user.calendar_events.build(start_time: start_time)
           calendar_event.find_or_build_work_session
           calendar_event.save
         end
       end
       redirect_to calendar_url
     end
  end  
   
 end