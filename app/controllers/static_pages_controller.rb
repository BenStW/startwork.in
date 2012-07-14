class StaticPagesController < ApplicationController
  skip_before_filter :authenticate_user!,  :except => [:welcome, :camera, :audio, :ben]
  
  def home
    session[:appointment_token] = nil
    if user_signed_in?
      if token = session[:appointment_token]
        session[:appointment_token] = nil
        redirect_to accept_url(:token=>token)
      else
        home_logged_in
        render :action=>'home_logged_in'
      end
    else
       render 'home_not_logged_in'
    end    
  end
    
  def home_logged_in    
    #TODO this is hack
    #  @app = if Rails.env.production? then "330646523672055" else "232041530243765" end #PRODUCTION
      @app = if Rails.env.production? then "331305516942290" else "232041530243765" end #RELEASE CANDIDATE

      @my_appointments = current_user.appointments.this_week
      @my_received_appointments = current_user.received_appointments.this_week
      @friends_appointments = Appointment.this_week.friends_of(current_user)
      @active_users = current_user.friends

      @friends = current_user.friends
      next_user_hour = current_user.user_hours.next
      if next_user_hour
        @next_group_hour = next_user_hour.group_hour
        users = @next_group_hour.users - [current_user]
        @user_names = users.map(&:name).join(", ")
        if @user_names.blank?
          @user_names = t("static_pages.home_logged_in.nobody")
        else
          @user_names = t("static_pages.home_logged_in.with")+" "+@user_names
        end
      end
      if !current_user.camera
        current_user.create_camera
      end
      @camera = current_user.camera
  end
  
  def home_not_logged_in
  end
  


  def login_to_accept_appointment  
     token = params["token"]
     session[:appointment_token] = token
     @appointment = Appointment.find_by_token(token)
     if @appointment.nil?
       render :json => "keine Verabredung gefunden"
     end
  end


  
# def session_start
#   if params[:success]
#     success = CameraAudio.find_or_create_by_user_id(current_user.id)
#     success.video_success=params[:success]
#     success.save
#     redirect_to audio_url
#   else
#     @api_key = TokboxApi.instance.api_key
#     @api_secret = TokboxApi.instance.api_secret
#     @session_id = TokboxApi.instance.get_session_for_camera_test
#     @tok_token = TokboxApi.instance.generate_token_for_camera_test
#   end
# end

  # called by *omniauth_callbacks_controller.rb*
  def welcome
    if current_user.registered
      redirect_to root_url
    else
      current_user.registered=true
      current_user.save    
      if token = session[:appointment_token]
        session[:appointment_token] = nil
        redirect_to accept_and_redirect_to_appointment_with_welcome_url(:token=>token)
      else
        @name = current_user.first_name
        @friends = current_user.friends
      end
   end    
  end
  


 # def welcome_session
 #   c = DateTime.current
 #   this_hour = DateTime.new(c.year,c.month,c.day, c.hour)
 #   calendar_event = current_user.calendar_events.build(start_time: this_hour)
 #   calendar_event.find_or_build_work_session
 #   calendar_event.save
 #   work_session = calendar_event.work_session    
 #      #    work_session = WorkSession.assign_for_guest(current_user)
 #       #   if work_session.nil?
 #      #      redirect_to root_url, :alert=> "Aktuell ist keine WorkSession vorhanden, wo Du als Gast teilnehmen kannst."
 #      #    else
 #   @work_buddies = work_session.users
 #
 # end
  

  
  def camera
    if params[:success]
      success = CameraAudio.find_or_create_by_user_id(current_user.id)
      success.video_success=params[:success]
      success.save
      redirect_to audio_url
    else
      @api_key = TokboxApi.instance.api_key
      @api_secret = TokboxApi.instance.api_secret
      @session_id = TokboxApi.instance.get_session_for_camera_test
      @tok_token = TokboxApi.instance.generate_token_for_camera_test
    end
  end  
  
  def audio
    if params[:success]
      success = CameraAudio.find_or_create_by_user_id(current_user.id)
      success.audio_success=params[:success]
      success.save
      if success.video_success==false or success.audio_success== false
        notice = t("static_pages.audio.no_success_msg")
      else
        notice = t("static_pages.audio.success_msg")
      end
      redirect_to root_url, :notice => notice
   end
 end
  
 
 def how_it_works
 end
 def effect
 end  
 def pilot_study
 end
 def scientific_principles
 end
 
 def impressum
 end
 def about_us
 end
 
 def ben
   
 end
 
 def blog
 end
 
 def info_for_group_hour
   
 end

end
