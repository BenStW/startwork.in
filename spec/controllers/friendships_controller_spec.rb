require 'spec_helper'


describe FriendshipsController do
 
  before(:each) do
    @user_ben = FactoryGirl.create(:user, :first_name=>"Benedikt", :last_name=>"Voigt")
    @user_steffi = FactoryGirl.create(:user, :first_name=>"Steffi", :last_name=>"Rothenberger")
    sign_in @user_ben
  end

  context "GET index" do
    
    it "should be success" do      
      get :index
      response.should be_success 
    end   
    
    it "should render index" do   
      get :index
      response.should render_template("index")
    end
        
    it "assigns all friendships" do
      friendship = FactoryGirl.create(:friendship, :user_id => @user_ben.id, :friend_id => @user_steffi.id)
      get :index
      assigns(:friendships).should eq([friendship])
    end
    
    it "assigns all other users without friendship" do
      get :index
      assigns(:users).should eq([@user_steffi])
    end    
    
    it "assigns all users in sorted order" do
      user_lars = Factory.create(:user, :first_name=>"Lars", :last_name=>"Geismann")
      get :index
      assigns(:users)[0].should eq(user_lars)
      assigns(:users)[1].should eq(@user_steffi)
    end  
    
    it "assigns all friends in sorted order" do
      user_lars = Factory.create(:user, :first_name=>"Lars", :last_name=>"Geismann")
      friendship = FactoryGirl.create(:friendship, :user_id => @user_ben.id, :friend_id => @user_steffi.id)
      friendship = FactoryGirl.create(:friendship, :user_id => @user_ben.id, :friend_id => user_lars.id)
      get :index
      assigns(:friendships)[0].friend.should eq(user_lars)
      assigns(:friendships)[1].friend.should eq(@user_steffi)
    end      
  end
  

  context "POST create" do
        
    it "should redirect to friendship_url" do
      post :create, :user_id => @user_ben.id, :friend_id => @user_steffi.id
      response.should redirect_to(friendship_url)
    end
    
    it "creates a reciproke friendship" do
       expect {
         post :create, :user_id => @user_ben.id, :friend_id => @user_steffi.id
       }.to change(Friendship, :count).by(2) # for forth and inverse friendship
       @user_ben.friends[0].should eq(@user_steffi)
       @user_steffi.friends[0].should eq(@user_ben)
    end 
    
    it "joins a work_session when two users become friends who had the same calendar event" do
      calendar_event_ben = FactoryGirl.create(:calendar_event, :user=>@user_ben)
      calendar_event_steffi = FactoryGirl.create(:calendar_event, :user=>@user_steffi)
      calendar_event_ben.work_session.should_not eq(calendar_event_steffi.work_session)
      expect {
        post :create, :user_id => @user_ben.id, :friend_id => @user_steffi.id
      }.to change(WorkSession, :count).by(-1)  
      calendar_event_ben.reload   
      calendar_event_steffi.reload
      calendar_event_ben.work_session.should eq(calendar_event_steffi.work_session)
   end
  end

 
  context "DELETE destroy" do
    it "destroys the requested friendship" do
      friendship = FactoryGirl.create(:friendship, :user_id => @user_ben.id, :friend_id => @user_steffi.id)
      inverse_friendship = FactoryGirl.create(:friendship, :user_id => @user_steffi.id, :friend_id => @user_ben.id)
 
      expect {
        delete :destroy, :id => friendship.to_param
      }.to change(Friendship, :count).by(-2)
    end
 
    it "redirects to the friendships list" do
      friendship = FactoryGirl.create(:friendship, :user_id => @user_ben.id, :friend_id => @user_steffi.id)
      inverse_friendship = FactoryGirl.create(:friendship, :user_id => @user_steffi.id, :friend_id => @user_ben.id)
      delete :destroy, :id => friendship.to_param
      response.should redirect_to(friendships_url)
    end
    
    it "re-assigns the user to new work_sessions" do
      new_user = FactoryGirl.create(:user_with_two_friends_and_same_events)
      
      sign_in new_user    
      friend1 = new_user.friendships[0].friend
      friend2 = new_user.friendships[1].friend

      new_user.calendar_events[0].work_session.should eq(friend1.calendar_events[0].work_session)     
      new_user.calendar_events[0].work_session.should eq(friend2.calendar_events[0].work_session)      
             
      delete :destroy, :id => new_user.friendships[0].id
     #new_user.calendar_events[0].work_session.reload
     #friend1.calendar_events[0].work_session.reload
     #friend2.calendar_events[0].work_session.reload
      new_user.calendar_events[0].reload
      friend1.calendar_events[0].reload
      friend2.calendar_events[0].reload      
      
      new_user.calendar_events[0].work_session.should_not eq(friend1.calendar_events[0].work_session)     
      new_user.calendar_events[0].work_session.should eq(friend2.calendar_events[0].work_session)      
    end 
            
      
  end

end
