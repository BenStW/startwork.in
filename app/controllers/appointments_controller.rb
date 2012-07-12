class AppointmentsController < ApplicationController
  skip_before_filter :authenticate_user!,  :only => [:show,:reject,:accept_without_authentication]
  
  
  
   def index
     @my_appointments = current_user.appointments  
     @my_user_hours = current_user.user_hours    
     @recipient_appointment = RecipientAppointment.new
   end

   def new
     @appointment = current_user.appointments.build   
   end

   def create
     a = current_user.appointments.create(params[:appointment])
     a.save
     redirect_to appointments_url
   end

   def edit
     @appointment = current_user.appointments.find(params[:id])
   end

   def update
      @appointment = current_user.appointments.find(params[:id])
      @appointment.update_attributes(params[:appointment])
     redirect_to appointments_url      
   end  

  def destroy
    a = current_user.appointments.find(params[:id])
    a.destroy
     redirect_to appointments_url
  end

  def send_appointment
    puts "params[:recipient_appointment] = #{params[:recipient_appointment].to_yaml}"
    user = User.find(params[:recipient_appointment]["user_id"])
    appointment = Appointment.find(params[:recipient_appointment]["appointment_id"])
    recipient_appointment = RecipientAppointment.create(:user=>user, :appointment=>appointment)
     redirect_to appointments_url 
  end
  
  def accept_appointment
    appointment = current_user.received_appointments.find(params[:id])
    Appointment.accept_received_appointment(current_user, appointment)  
    redirect_to appointments_url
  end
  
  
  
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
     
     # Shows the user two links:
     # reject appointment: --> appointment_reject_url
     # accept appointment: --> appointment_accept_without_authentication_url(:token=> @appointment.token)
  end
  
  def reject
     redirect_to root_url
  end  
  
  def accept_without_authentication
    session[:appointment_token] = params["token"]

    # the following redirect does not work because of FB login.
    # The user is redirected to root_url. 
    # Therefore root_url must redirect to appointment_accept_url
     redirect_to appointment_accept_url
  end
  
  def accept
    token = params["token"]
    appointment = Appointment.find_by_token(token)    
    if appointment.nil?
      render :json => "keine Verabredung gefunden."
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
       redirect_to welcome_with_appointment_url(:token => token)
     end
  end  
   
 end