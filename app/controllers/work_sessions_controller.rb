class WorkSessionsController < ApplicationController
  skip_before_filter :authenticate_user!,  :only => [:test_show]  
  layout "video_layout"

  def show  
    calendar_event = current_user.calendar_events.current 
    if calendar_event.nil?
      calendar_event = current_user.create_calendar_event_now
    end
    calendar_event.store_login 
    @tokbox_session_id = calendar_event.work_session.room.tokbox_session_id
    @room_name = "#{calendar_event.work_session.room.user.name}'s room"
    @tokbox_token = TokboxApi.instance.generate_token @tokbox_session_id, current_user
    @tokbox_api_key = TokboxApi.instance.api_key
  end  
  
  def show_tmp
    redirect_to work_session_url
  end    
  
  def room_change
     calendar_event = current_user.calendar_events.current 
     if calendar_event.nil?
         calendar_event = current_user.create_calendar_event_now
     end
     calendar_event.store_login
     if calendar_event.work_session.room.tokbox_session_id == params[:session]
        render :json => false
      else
        render :json => true
      end
  end
  
  def get_time
    render :json => DateTime.current
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
  
end
