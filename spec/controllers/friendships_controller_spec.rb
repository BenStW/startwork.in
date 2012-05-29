require 'spec_helper'


describe FriendshipsController do
 
# before(:each) do
#   @user_ben = FactoryGirl.create(:user, :first_name=>"Benedikt")
#   @user_robert = FactoryGirl.create(:user, :first_name=>"Robert", :fb_ui => "4711")
#   FactoryGirl.create(:friendship, :user_id => @user_ben.id, :friend_id => @user_robert.id)    
#   sign_in @user_ben
#   
#   @fb_friend_robert = mock("FbGraph::User", :name => "Robert Sarrazin", :identifier => "4711")
#   @fb_friend_miro = mock("FbGraph::User", :name => "Miro Wilms", :identifier => "4712")
#
#   fb_friends = [@fb_friend_robert,@fb_friend_miro]
#   FbGraph::User.stub_chain(:new, :fetch, :friends).and_return(fb_friends)
# end
#
# context "GET index" do
#   
#   it "should be success" do      
#     get :index
#     response.should be_success 
#   end  
#   
#   it "should render index" do   
#     get :index
#     response.should render_template("index")
#   end
#       
#   it "assigns all friends" do
#     get :index
#     assigns(:friends).should eq([@user_robert])
#   end
#   
#   it "should assign the facebook friends who are no workbuddies" do
#     get :index
#     assigns(:facebook_friends).count.should eq(1)
#     assigns(:facebook_friends)[0].name.should eq("Miro Wilms") 
#     assigns(:facebook_friends)[0].identifier.should eq("4712") 
#   end
#   
#   it "assigns all friends in sorted order" do
#     user_lars = Factory.create(:user, :first_name=>"Lars")
#     user_stefan = Factory.create(:user, :first_name=>"Stefan")      
#     FactoryGirl.create(:friendship, :user_id => @user_ben.id, :friend_id => user_lars.id)
#     FactoryGirl.create(:friendship, :user_id => @user_ben.id, :friend_id => user_stefan.id)
#     get :index
#     assigns(:friends)[0].should eq(user_lars)
#     assigns(:friends)[1].should eq(@user_robert)
#     assigns(:friends)[2].should eq(user_stefan)
#   end  
#   
#   it "assigns all facebook friends in sorted order" do
#     fb_friend_lars = mock("FbGraph::User", :name => "Lars", :identifier => "4713")
#     fb_friend_stefan = mock("FbGraph::User", :name => "Stefan", :identifier => "4714")
#     fb_friends = [@fb_friend_robert,@fb_friend_miro,fb_friend_lars,fb_friend_stefan]
#     FbGraph::User.stub_chain(:new, :fetch, :friends).and_return(fb_friends)   
#     get :index
#     assigns(:facebook_friends)[0].should eq(fb_friend_lars)
#     assigns(:facebook_friends)[1].should eq(@fb_friend_miro)
#     assigns(:facebook_friends)[2].should eq(fb_friend_stefan)
#   end               
# end
# 
# context "POST create_with_all_fb_friends" do
#   
#   it "should create a workbuddy for a facebook friend" do
#     expect {
#       post :create_all_fb_friends        
#     }.to change(User, :count).by(1)      
#   end
#   
#   it "should create a reciproke friendship to the new workbuddy" do
#     post :create_all_fb_friends
#     user_miro = User.find_by_fb_ui(@fb_friend_miro.identifier)
#     user_miro.friends[0].should eq(@user_ben)
#     @user_ben.friends.last.should eq(user_miro)
#   end
#   
#   it "should redirect to friendships_url" do
#     post :create_all_fb_friends
#     response.should redirect_to(friendships_url)      
#   end
# 
# end
#
  

# context "POST create_with_fb_friend" do
#   
#   before(:each) do
#     fb_robert = mock("FbGraph::User", :first_name => "Robert", :last_name =>" Sarrazin", :identifier => "4711")
#     FbGraph::User.stub(:fetch).with("4711").and_return(fb_robert)
#   end
#   
#   it "should create a user for a facebook friend when he is marked as WorkBuddy" do
#     puts "identifier = #{@fb_friend_robert.identifier}"
#     expect {
#       post :create_with_fb_friend, :fb_ui => @fb_friend_robert.identifier
#     }.to change(User, :count).by(1)
#     User.last
#           
#   end
#   
#   it "should redirect to friendship_url when succussful" do
#     post :create_with_fb_friend, :fb_ui => @fb_friend_robert.identifier
#     response.should redirect_to(friendship_url)
#   end
#   
#   it "creates a reciproke friendship" do
#      expect {
#        post :create_with_fb_friend, :fb_ui => @fb_friend_robert.identifier
#      }.to change(Friendship, :count).by(2) # for forth and inverse friendship
#      user_robert = User.find_by_fb_ui(@fb_friend_robert.identifier)
#      @user_ben.friends[0].should eq(user_robert)
#      user_robert.friends[0].should eq(@user_ben)
#   end
# end
# 
#  context "POST create" do    
#    
#        
#    it "should redirect to friendship_url when succussful" do
#      post :create, :user_id => @user_ben.id, :friend_id => @user_steffi.id
#      response.should redirect_to(friendship_url)
#    end
#    
#    it "creates a reciproke friendship" do
#       expect {
#         post :create, :user_id => @user_ben.id, :friend_id => @user_steffi.id
#       }.to change(Friendship, :count).by(2) # for forth and inverse friendship
#       @user_ben.friends[0].should eq(@user_steffi)
#       @user_steffi.friends[0].should eq(@user_ben)
#    end 
#    
#    it "joins a work_session when two users become friends who had the same calendar event" do
#      calendar_event_ben = FactoryGirl.create(:calendar_event, :user=>@user_ben)
#      calendar_event_steffi = FactoryGirl.create(:calendar_event, :user=>@user_steffi)
#      calendar_event_ben.work_session.should_not eq(calendar_event_steffi.work_session)
#      expect {
#        post :create, :user_id => @user_ben.id, :friend_id => @user_steffi.id
#      }.to change(WorkSession, :count).by(-1)  
#      calendar_event_ben.reload   
#      calendar_event_steffi.reload
#      calendar_event_ben.work_session.should eq(calendar_event_steffi.work_session)
#   end
#   
#   it "does not allow to create 11 friends" do
#     (1..11).each do |index|
#       user = FactoryGirl.create(:user)
#       post :create, :user_id => @user_ben.id, :friend_id => user.id
#     end
#     @user_ben.friends.count.should eq(10)
#   end
#   
#   it "should redirect to friendship_url when tried to create the 11th friend" do
#      (1..11).each do |index|
#        user = FactoryGirl.create(:user)
#        post :create, :user_id => @user_ben.id, :friend_id => user.id
#        response.should redirect_to(friendship_url)
#      end   
#    end
#   
#   it "should output the flash alert 'You can have only 10 workbuddies at maximum' when tried to create the 11th friend" do
#     (1..11).each do |index|
#       user = FactoryGirl.create(:user)
#       post :create, :user_id => @user_ben.id, :friend_id => user.id
#     end
#     flash[:alert].should eql("You can have only 10 workbuddies at maximum.")
#   end
#  end
# 
# 
#  context "DELETE destroy" do
#    it "destroys the requested friendship" do
#      friendship = FactoryGirl.create(:friendship, :user_id => @user_ben.id, :friend_id => @user_steffi.id)
#      inverse_friendship = FactoryGirl.create(:friendship, :user_id => @user_steffi.id, :friend_id => @user_ben.id)
# 
#      expect {
#        delete :destroy, :id => friendship.to_param
#      }.to change(Friendship, :count).by(-2)
#    end
# 
#    it "redirects to the friendships list" do
#      friendship = FactoryGirl.create(:friendship, :user_id => @user_ben.id, :friend_id => @user_steffi.id)
#      inverse_friendship = FactoryGirl.create(:friendship, :user_id => @user_steffi.id, :friend_id => @user_ben.id)
#      delete :destroy, :id => friendship.to_param
#      response.should redirect_to(friendships_url)
#    end
#    
#    it "re-assigns the user to new work_sessions" do
#      new_user = FactoryGirl.create(:user_with_two_friends_and_same_events)
#      
#      sign_in new_user    
#      friend1 = new_user.friendships[0].friend
#      friend2 = new_user.friendships[1].friend
# 
#      new_user.calendar_events[0].work_session.should eq(friend1.calendar_events[0].work_session)     
#      new_user.calendar_events[0].work_session.should eq(friend2.calendar_events[0].work_session)      
#             
#      delete :destroy, :id => new_user.friendships[0].id
#     #new_user.calendar_events[0].work_session.reload
#     #friend1.calendar_events[0].work_session.reload
#     #friend2.calendar_events[0].work_session.reload
#      new_user.calendar_events[0].reload
#      friend1.calendar_events[0].reload
#      friend2.calendar_events[0].reload      
#      
#      new_user.calendar_events[0].work_session.should_not eq(friend1.calendar_events[0].work_session)     
#      new_user.calendar_events[0].work_session.should eq(friend2.calendar_events[0].work_session)      
#    end 
#            
#      
#  end
  
end
