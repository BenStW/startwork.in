class PenaltiesController < ApplicationController
  def latest
    @penalty = Penalty.last
    from_user_name = @penalty.from_user.name
    to_user_name = @penalty.to_user.name
    from_user_id = @penalty.from_user.id
    to_user_id = @penalty.to_user.id  
    penalty_hash = { 
       from_user_name: from_user_name,
       to_user_name: to_user_name,
       from_user_id: from_user_id,
       to_user_id: to_user_id       
       }.to_json
    render :json => penalty_hash
  end
  
  def add
    @penalty = Penalty.new
    @penalty.from_user_id = params[:from_user_id]
    @penalty.to_user_id = params[:to_user_id]
    @penalty.start_time=DateTime.current
    @penalty.save
    render :json => @penalty
  end
end
