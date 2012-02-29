class PenaltiesController < ApplicationController
  def latest
    @penalty = Penalty.last
    from_user_name = @penalty.from_user.name
    to_user_name = @penalty.to_user.name
    from_user_id = @penalty.from_user.id
    to_user_id = @penalty.to_user.id  
    penalty_hash = {
       penalty_id: @penalty.id, 
       from_user_name: from_user_name,
       to_user_name: to_user_name,
       from_user_id: from_user_id,
       to_user_id: to_user_id       
       }.to_json
    render :json => penalty_hash
  end
  
  def add
    #TODO: only add penalty when no open penalty is there
    to_user_id = params[:to_user_id]
    to_user = User.find(to_user_id)
    if !to_user.open_penalties?
      @penalty = Penalty.new
      @penalty.from_user_id = params[:from_user_id]
      @penalty.to_user_id = params[:to_user_id]
      @penalty.start_time=DateTime.current
      @penalty.save
      logger.info "no open penalties. Create penalty from user #{@penalty.from_user_id} to user #{@penalty.to_user_id}"
      render :json => @penalty
    else
      logger.info "open penalties for user_id #{to_user_id} exist. Don't create a new one"
      render :json => {}
    end
  end
  
  def end
    penalty_id = params[:penalty_id]
    @penalty = Penalty.find(penalty_id)
    @penalty.end_time = DateTime.current
    @penalty.excuse = params[:excuse]
    @penalty.save
    render :json => { msg: "succussfully updated the end of the penalty"}
  end  
  
  def cancel
    penalty_id = params[:penalty_id]
    logger.info "delete penalty #{penalty_id}"
    @penalty = Penalty.find(penalty_id)
    @penalty.destroy    
    render :json => { msg: "succussfully destroyed"}
  end
end
