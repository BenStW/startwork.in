require 'spec_helper'

describe WorkSessionsController do
  render_views
  fixtures :work_sessions
  fixtures :users
  

  it "creates a user token" do
    work_session =  work_sessions(:procrastinators)
    
    user_ben = users(:ben)    
    
    sign_in user_ben   
    get :show, :id=>work_session.id

    assigns[:tokbox_token].should_not be_nil
  end 

end
