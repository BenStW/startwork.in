class StaticPagesController < ApplicationController
  def home
  end

  def how_it_works
  end
  def contact
  end
  def about_us
  end
  def camera
    @api_key = 11796762                # should be a number
    @api_secret = 'f6989f3520873c70f414edfd3f5d02e88ab4a97b'            # should be a string
    @apiObj = OpenTok::OpenTokSDK.new @api_key, @api_secret
    @session_id = @apiObj.create_session(request.remote_addr ) 
    @tok_token = @apiObj.generate_token session_id: @session_id
  end  
end
