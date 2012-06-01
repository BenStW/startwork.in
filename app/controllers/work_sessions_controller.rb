class WorkSessionsController < ApplicationController
  skip_before_filter :authenticate_user!,  :only => [:test_show]  
  layout "video_layout"
  
  def show
    
    work_session = nil
    if guest = params[:guest]
      work_session = WorkSession.assign_for_guest(current_user)

    else
      work_session = next_work_session
    end
  
    if work_session.nil?
      if guest
         render :text =>  t("work_sessions.show.no_guest_work_session")
      else
        render :text =>  t("work_sessions.show.no_work_session")
      end
    else
        @tokbox_session_id = work_session.room.tokbox_session_id
        @room_name = "#{work_session.room.user.name}'s room"

        #@work_buddies = work_session.users - [current_user] + [guest_work_buddy]
             
        @tokbox_token = TokboxApi.instance.generate_token @tokbox_session_id, current_user, guest
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

  
    
  def can_we_start
    render :json => next_work_session.nil? ? false : true
  end
  
  private 

  def next_work_session
    calendar_event = current_user.calendar_events.next    
    if !calendar_event.nil?
      work_session = calendar_event.work_session
      min_diff = (DateTime.current - work_session.start_time.to_datetime()) * 24 * 60
      
      if min_diff >= -5 and min_diff<=55
        work_session
      else
        nil
      end
    end 
  end
  
end
