class GroupHoursController < ApplicationController
  skip_before_filter :authenticate_user!,  :only => [:test_show]  
  layout "video_layout"

  def show  
    @user_hour = current_user.user_hours.current 
    if @user_hour.nil?
      current_user.create_appointment_now
      @user_hour = current_user.user_hours.current 
    end
    group_hour = @user_hour.group_hour
    if group_hour.users.count<2
      Appointment.accept_foreign_appointment_now(current_user)
    end
    @user_hour.reload
    @user_hour.store_login 
    
    InfoMailer.deliver_session_start(current_user,@user_hour.group_hour).deliver       

    @tokbox_session_id = group_hour.tokbox_session_id
    @tokbox_token = TokboxApi.instance.generate_token @tokbox_session_id, current_user
    @tokbox_api_key = TokboxApi.instance.api_key
  end  
 
  
 # def room_change
 #    user_hour = current_user.user_hours.current 
 #    if user_hour.nil?
 #        render :json => true
 #    else
 #      user_hour.store_login
 #      if user_hour.group_hour.tokbox_session_id == params[:session]
 #         render :json => false
 #       else
 #         render :json => true
 #       end
 #     end
 # end
 # 
  def get_time
    render :json => DateTime.current
  end
  
  def group_hours
     @group_hours = WorkSession.this_week
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
