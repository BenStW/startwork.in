class WorkSessionsController < ApplicationController
  skip_before_filter :authenticate_user!,  :only => [:test_show]  
  layout "video_layout"
  
  
 # def guest_show    
 #   work_session = WorkSession.assign_for_guest(current_user)
 #   if work_session.nil?
 #        render :text =>  t("work_sessions.show.no_guest_work_session")    
 #   end
 # end
  
  def spont_show
    if current_user.current_work_session.nil?
       c = DateTime.current
       this_hour = DateTime.new(c.year,c.month,c.day, c.hour)
       calendar_event = current_user.calendar_events.build(start_time: this_hour)
       calendar_event.find_or_build_work_session
       calendar_event.save
    end
    redirect_to work_session_path     
  end
  
  def show  
    work_session = current_user.current_work_session  
    if work_session.nil?
        render :text =>  t("work_sessions.show.no_work_session")
    else
        current_user.calendar_events.current.store_login 
        @tokbox_session_id = work_session.room.tokbox_session_id
        @room_name = "#{work_session.room.user.name}'s room"
        @tokbox_token = TokboxApi.instance.generate_token @tokbox_session_id, current_user #, guest
        @tokbox_api_key = TokboxApi.instance.api_key
    end
  end  
    
  
  def test_show
    user = params[:user]
   # if ![1,2].include?(user_id)
  #    render :text => "user must be 1 or 2"
  #  end
    @tokbox_session_id = "1_MX4xMzE4NzY1Mn5-MjAxMi0wNS0zMCAxODozMjozNy4wNjMxNTcrMDA6MDB-MC42NDI2MzUyMzI2MTJ-"
    @room_name = "Test room"
   # @work_buddy = if user_id==1 then 2 else 1 end
   # puts "XXXXX work_buddy=#{@work_buddy}"
         
    @tokbox_token = TokboxApi.instance.generate_token @tokbox_session_id, user, "test"
    @tokbox_api_key = TokboxApi.instance.api_key    
  end
  
  def room_change
     session = params[:session]
     work_session = current_user.current_work_session
     if work_session and work_session.room.tokbox_session_id == session
        render :json => false
      else
        render :json => true
      end
  end
  
  def get_time
    render :json => DateTime.current
  end

  
  def can_we_start
    render :json => current_user.current_work_session.nil? ? false : true
  end
  
  def homepage
    render :layout => 'homepage_layout'
  end
  


  
end
