require 'spec_helper'

describe ConnectionsController do
 # render_views  

  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end
  
  context "start" do
    it "should start the connection for one user" do
      @user.should_not be_open_connections
      post :start, :user_ids => [@user.id]
      @user.should be_open_connections    
    end
    it "should start the connection for multiple user" do
      new_user = FactoryGirl.create(:user)
      @user.should_not be_open_connections
      new_user.should_not be_open_connections
      post :start, :user_ids => [@user.id,new_user.id]
      @user.should be_open_connections    
      new_user.should be_open_connections          
    end
  
  end
  
  context "end" do
    it "should end a connection for a user" do
      @user.should_not be_open_connections
      post :start, :user_ids => [ @user.id]
      @user.should be_open_connections
      post :end, :user_ids  => [@user.id]
      @user.should_not be_open_connections      
    end
    
    it "should end a connection for a multiple users" do
      new_user = FactoryGirl.create(:user)
      @user.should_not be_open_connections
      new_user.should_not be_open_connections
      post :start, :user_ids => [@user.id,new_user.id]
      @user.should be_open_connections
      new_user.should be_open_connections
      post :end, :user_ids => [@user.id,new_user.id]
      @user.should_not be_open_connections      
      new_user.should_not be_open_connections      
    end    
  end 

end
