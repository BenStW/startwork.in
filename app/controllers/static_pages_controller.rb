class StaticPagesController < ApplicationController
  skip_before_filter :authenticate_user!
  
  def home  
    if current_user
      next_calendar_event = current_user.calendar_events.next
      if next_calendar_event.count>0
        @next_work_session = next_calendar_event[0].work_session
        users = @next_work_session.users - [current_user]
        @user_names = users.map(&:name).join(", ")
        if @user_names.blank?
          @user_names = t("static_pages.home.nobody")
        else
          @user_names = t("static_pages.home.with")+" "+@user_names
        end
        @room_host = @next_work_session.room.user.name
      end
    end
  end

  def how_it_works
  end
  def contact
  end
  def about_us
  end
  def study
  end  
  
  def facebook
  end
  
  def interested_user
    flash[:notice] = "The user was successfully created"
  end

  
  def camera
    @api_key = TokboxApi.instance.api_key
    @api_secret = TokboxApi.instance.api_secret
    @session_id = TokboxApi.instance.get_session_for_camera_test
    @tok_token = TokboxApi.instance.generate_token_for_camera_test
  end  
end
