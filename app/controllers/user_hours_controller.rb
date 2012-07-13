class UserHoursController < ApplicationController
  
  def index
   #  @friends = current_user.friends
  #   @app = if Rails.env.production? then "330646523672055" else "232041530243765" end
     @user_hours = UserHour.this_week  #for JSON
  end

end

