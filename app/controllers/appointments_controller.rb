class AppointmentsController < ApplicationController
  skip_before_filter :authenticate_user!,  :only => [:show,:reject]
  
  
  # appointment_url (appointments#show) (when logged in, store the appointment as received) 
  # -> 1) reject_appointment_url
  #        -> root_url
  # -> 2) accept_appointment_url (when logged in)
  #        -> root_url
  # -> 3) login_to_accept_appointment (stores token as cookie)
  #        -> welcome_url (default after facebook login, removes cookie)
  #        -> accept_and_redirect_to_appointment_with_welcome
  #        -> show_and_welcome_appointment
  #
  
    
   def index
     @my_appointments = current_user.appointments.this_week
     my_or_friends = "my"
     render :partial => "appointments", 
         :locals => { :appointments => @my_appointments, :my_or_friends => my_or_friends } 
   end

   
   def show
     token = params[:token]
     @appointment = Appointment.find_by_token!(token)
     if current_user
       @appointment.receive(current_user)
     end
    end   

   def create
     start_time = DateTime.parse(params[:appointment][:start_time])
     end_time = DateTime.parse(params[:appointment][:end_time])
     appointment = current_user.appointments.create(:user=>current_user, :start_time=>start_time, :end_time=>end_time)     
     if appointment.valid?
        render :json => appointment.to_json(:only => [ :id, :token, :start_time, :end_time ])
      else
        render :template => "errors/404", :layout => 'application', :status => 404    
      end
   end

   def update
      @appointment = current_user.appointments.find(params[:id])
      @appointment.start_time = DateTime.parse(params[:appointment][:start_time])
      @appointment.end_time = DateTime.parse(params[:appointment][:end_time])
      @appointment.save
      if @appointment.valid?
         render :json => "ok"   
      else
          render :text => "appointment could not be saved", :status => :unprocessable_entity
      end        
   end  

  def destroy
    a = current_user.appointments.find(params[:id])
    a.destroy
    render :json => "ok"
  end

 
  def show_and_welcome
     @name = current_user.first_name
     token = params["token"]
     @appointment = Appointment.find_by_token!(token)
     @appointment.receive(current_user)  
          
     @friends = current_user.friends - [@appointment.user]
  end  
 
  def reject
     redirect_to root_url
  end
  
  def accept
    appointment = Appointment.find_by_token!(params[:token])
    appointment.receive_and_accept(current_user)
     
   respond_to do |format|
     format.html { redirect_to root_url }
     format.json { render :json => "ok" }
   end      
  end
  
  
  def accept_and_redirect_to_appointment_with_welcome
    token = params[:token]
    appointment = Appointment.find_by_token!(token)

    appointment.receive_and_accept(current_user)
    
    
    redirect_to show_and_welcome_appointment_url(:token => token)
  end  
  
  def receive
    appointment = current_user.appointments.find(params[:appointment_id])
    user_ids = params[:user_ids]
    user_ids.each do |fb_ui|
       user = User.find_for_facebook_request(fb_ui)
       appointment.receive(user)
     end
    render :json => "ok"
  end  
  
  
  
  # this action "overview" is used only for internal testing
  def overview
    @my_appointments = current_user.appointments  
    @my_user_hours = current_user.user_hours  
    @recipient_appointment = RecipientAppointment.new  
  end

  # this action "new" is used only for internal testing  
  def new
    @appointment = current_user.appointments.build   
  end
  
  # this action "edit" is used only for internal testing    
  def edit
    @appointment = current_user.appointments.find(params[:id])
  end
  

  
  # this action "send_appointment" is used only for internal testing    
  def send_appointment
    user = User.find!(params[:recipient_appointment]["user_id"])
    appointment = Appointment.find(params[:recipient_appointment]["appointment_id"])
    recipient_appointment = RecipientAppointment.create(:user=>user, :appointment=>appointment)
     redirect_to appointments_url 
  end  
   
   
 end