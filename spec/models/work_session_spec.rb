# == Schema Information
#
# Table name: work_sessions
#
#  id         :integer         not null, primary key
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  start_time :datetime
#  room_id    :integer
#

require 'spec_helper'

describe WorkSession do

 describe "attributes" do
    before(:each) do
      @work_session = FactoryGirl.create(:work_session) 
    end
    
    it "is valid with attributes start_time and room" do
      @work_session.should be_valid
    end
   
    it "is not valid without start_time" do
      @work_session.start_time = nil
      @work_session.should_not be_valid
    end
    
    it "is not valid without a room " do
      @work_session.room_id = nil
      @work_session.should_not be_valid
    end  
  end

   describe "finding of the right work session" do

     # create two users: user1 and user2,
     # create a calendar event and a work session for the user1
     before(:each) do
      @user1 = FactoryGirl.create(:user)
      @user2 = FactoryGirl.create(:user)     

      @user1_room = FactoryGirl.create(:room, :user=>@user1)    
      @user1_time = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,10)+1.day
      @user1_work_session = FactoryGirl.create(:work_session, :start_time=>@user1_time, :room=>@user1_room)
      @user1_calendar_event = FactoryGirl.create(:calendar_event, 
        :work_session=>@user1_work_session, :user=>@user1, :start_time=>@user1_time)
     end
     
     it "finds the work session of a friend at the same time" do
       Friendship.any_instance.stub(:update_work_sessions_after_create).and_return(nil)  
       f1 = @user2.friendships.create(:friend => @user1)
       f2 = @user2.inverse_friendships.create(:user_id => @user1)
                 
       work_session = WorkSession.find_work_session(@user2, @user1_time)
       work_session.should == @user1_work_session
     end
     it "finds no work session if user at the same time is no friend" do
        work_session = WorkSession.find_work_session(@user2, @user1_time)
        work_session.should be_nil
     end
     it "finds no work session if the time is different to friends work session" do
       Friendship.any_instance.stub(:update_work_sessions_after_create).and_return(nil)  
       f1 = @user2.friendships.create(:friend => @user1)
       f2 = @user2.inverse_friendships.create(:user_id => @user1)
                 
       work_session = WorkSession.find_work_session(@user2, @user1_time+1.hour)
       work_session.should be_nil
     end
    
   end

end
