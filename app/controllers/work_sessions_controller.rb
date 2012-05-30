class WorkSessionsController < ApplicationController
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
        guest_work_buddy = User.new(:first_name=>"Gast")
        @work_buddies = work_session.users - [current_user] + [guest_work_buddy]
             
        @tokbox_token = TokboxApi.instance.generate_token @tokbox_session_id, current_user, guest
        @tokbox_api_key = TokboxApi.instance.api_key
      end
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
