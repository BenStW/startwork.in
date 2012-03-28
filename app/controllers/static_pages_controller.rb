class StaticPagesController < ApplicationController
  skip_before_filter :authenticate_user!
  
  def home  
    first_room = Room.first
    if first_room.nil?
      @group1_id=0
      @group2_id=0
    else
      @group1_id = first_room.id
      @group2_id =  @group1_id+1
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
