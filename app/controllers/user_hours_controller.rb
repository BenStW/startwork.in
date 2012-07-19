class UserHoursController < ApplicationController
  
  def index
     @user_hours = UserHour.this_week  #for JSON
  end

end

