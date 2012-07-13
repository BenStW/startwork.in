class CamerasController < ApplicationController

  def show
      @camera = current_user.camera    
      @api_key = TokboxApi.instance.api_key
      @api_secret = TokboxApi.instance.api_secret
      @session_id = TokboxApi.instance.get_session_for_camera_test
      @tok_token = TokboxApi.instance.generate_token_for_camera_test
  end

   def update
      @camera = current_user.camera
      @camera.update_attributes(params[:camera]) 
      redirect_to camera_url    
   end  

end