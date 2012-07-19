require 'spec_helper'
#require 'ruby-debug19'

describe UserHoursController do
  render_views
  
 context "index" do
   before(:each) do
     @my_user = FactoryGirl.create(:user)
     sign_in @my_user
     @my_appointment = FactoryGirl.create(:appointment, :user=>@my_user)
     
     @friend = FactoryGirl.create(:user)
     Friendship.create_reciproke_friendship(@my_user, @friend)
     @friend_appointment = FactoryGirl.create(:appointment, :user=>@friend)
     
     @other = FactoryGirl.create(:user)
     @other_appointment = FactoryGirl.create(:appointment, :user=>@other)
   end
   
   it "should be success" do      
     get :index, :format=>:json
     response.should be_success 
   end   
   
   it "should return the user_hours of the three appointments" do
     get :index, :format=>:json     
     body = response.body
     obj = ActiveSupport::JSON.decode(body) 
     obj.count.should eq(6)
   end      
  
 end

end
