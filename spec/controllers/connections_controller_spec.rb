require 'spec_helper'

describe ConnectionsController do
 # render_views  

  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end
  
  context "start" do
    
  end

  it "should start connection" do
    @user.should_not be_open_connections
    post :start, :user_ids => [@user.id]
    @user.should be_open_connections
  end
  
  it "should end connection" do
      @user.should_not be_open_connections
      post :start, :user_ids => [ @user.id]
      @user.should be_open_connections
      post :end, :user_ids  => [@user.id]
      @user.should_not be_open_connections
  end   

end
