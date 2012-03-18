class StaticPagesController < ApplicationController
  skip_before_filter :authenticate_user!
  
  def home  
    @group1_id = WorkSession.first.id
    @group2_id =  @group1_id+1
  end

  def how_it_works
  end
  def contact
  end
  def about_us
  end
  def study
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
