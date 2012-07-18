class GroupHoursController < ApplicationController
  skip_before_filter :authenticate_user!,  :only => [:test_show]  
  layout "video_layout"
  
  def show  
    puts "#{current_user.name}: ******** SHOW GROUP HOUR *********"    
    @user_hour = current_user.user_hours.current 
        
    if @user_hour.nil?
      current_user.create_appointment_now
      @user_hour = current_user.user_hours.current 
      puts "#{current_user.name}: user_hour was NIL. created new user_hour = #{@user_hour.id}"
    else
      puts "#{current_user.name}: user_hour NOT NIL = #{@user_hour.id}"
    end
      
    group_hour = @user_hour.group_hour
    puts "#{current_user.name}: group_hour = #{group_hour.id} with #{group_hour.users.count} users"    
    if group_hour.users.count<2
      Appointment.accept_foreign_appointment_now(current_user)
      puts "#{current_user.name}: accept_foreign_appointment_now "          
    end
    @user_hour.reload
    @user_hour.store_login 
    puts "#{current_user.name}: user_hour = #{@user_hour.id}"    
    
    InfoMailer.deliver_session_start(current_user,@user_hour.group_hour).deliver       

    @tokbox_session_id = group_hour.tokbox_session_id
    @tokbox_token = TokboxApi.instance.generate_token @tokbox_session_id, current_user
    @tokbox_api_key = TokboxApi.instance.api_key
    puts "#{current_user.name}: ******** END OF SHOW GROUP HOUR *********"    
    
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
