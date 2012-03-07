require 'spec_helper'

describe ConnectionsController do
  render_views  
  fixtures :users

  it "should start connection" do
    user_ben = users(:ben)
    sign_in user_ben
    user_ben.should_not be_open_connections
    post :start, :user_ids => [user_ben.id]
    user_ben.should be_open_connections
  end
  
  it "should end connection" do
      user_ben = users(:ben)
      sign_in user_ben
      user_ben.should_not be_open_connections
      post :start, :user_ids => [user_ben.id]
      user_ben.should be_open_connections
      post :end, :user_ids  => [user_ben.id]
      user_ben.should_not be_open_connections
  end   

end
