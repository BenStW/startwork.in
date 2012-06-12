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
  
 
  context "attributes" do
    
    before(:each) do
      @work_session = FactoryGirl.create(:work_session)
      #Room.any_instance.stub(:populate_tokbox_session).and_return("tokbox_session_id") 
    end
    
    it "should be valid with attributes from the factory" do
      @work_session.should be_valid
    end
    
    it "should not be valid without start_time" do
      @work_session.start_time = nil
      @work_session.should_not be_valid
    end
    
    it "should not be valid without a room" do
      @work_session.room = nil
      @work_session.should_not be_valid
    end
  end
  
  context "with class methods" do
    
    before(:each) {  @work_session = FactoryGirl.create(:work_session) }
    
    it "selects work_sessions of this week" do
      WorkSession.this_week.count.should eq(1)
    end
    
    it "does not select work_sessions of last week" do
      yesterday = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,10)-1.day
      last_work_session = FactoryGirl.create(:work_session,:start_time=>yesterday)
      WorkSession.count.should eq(2)
      WorkSession.this_week.count.should eq(1)
    end
    
    it "selects work_sessions of a start_time " do
      WorkSession.start_time(@work_session.start_time).count.should eq(1)
    end
    
    it "does not select work_sessions of other start_times " do
      new_start_time = @work_session.start_time + 1.hour
      WorkSession.start_time(new_start_time).count.should eq(0)
    end
    
    it "finds current work session" do
       DateTime.stub(:current).and_return(@work_session.start_time+10.minutes)
       ws = WorkSession.current
       ws.count.should eq(1)
       ws[0].should eq(@work_session)  
    end
    it "finds not the work session in 70 minutes when searched for current" do
      DateTime.stub(:current).and_return(@work_session.start_time+70.minutes)
      ws = WorkSession.current
      ws.count.should eq(0)
    end
    it "finds not the work session before 10 minutes when searched for current" do
      DateTime.stub(:current).and_return(@work_session.start_time-10.minutes)
      ws = WorkSession.current
      ws.count.should eq(0)  
    end
  end
  
  context "with class methods to find and assign a guest work session" do
    
    before(:each) do 
       @user = FactoryGirl.create(:user)
       @work_session = FactoryGirl.create(:work_session)
    end
    
    it "finds a worksession without guest" do
      ws = WorkSession.free_for_guest(@user)
      ws[0].should eq(@work_session)
    end
    
    it "finds a worksession with user as guest" do
      @work_session.guest_id = @user.id
      @work_session.save
      ws = WorkSession.free_for_guest(@user)
      ws[0].should eq(@work_session)     
    end
    
    it "does not find a worksession when guest is occupied" do
      @work_session.guest_id = 4711
      @work_session.save
      ws = WorkSession.free_for_guest(@user)
      ws.count.should eq(0)    
    end

    
    it "assigns a guest to a work session" do
      WorkSession.stub_chain(:current,:free_for_guest,:first).and_return(@work_session)
      ws = WorkSession.assign_for_guest(@user)
      ws.guest_id.should eq(@user.id)
    end
    it "returns a work session" do
      WorkSession.stub_chain(:current,:free_for_guest,:first).and_return(@work_session)
      ws = WorkSession.assign_for_guest(@user)
      ws.should eq(@work_session)
    end    
    
  end
  
  context "with calender_events" do
    before(:each) do 
      # the work_session stores the stored through calenar_events.
      # Therefore the calendar_events must be first created      
      @user1 = FactoryGirl.create(:user)
      @user2 = FactoryGirl.create(:user)
      @calendar_event1 = FactoryGirl.create(:calendar_event, :user=>@user1)
      @calendar_event2 = FactoryGirl.create(:calendar_event, :user=>@user2)
      @work_session1 = @calendar_event1.work_session
      @work_session2 = @calendar_event2.work_session
    end    

    it "selects by user_ids" do
      WorkSession.count.should eq(2)
      WorkSession.has_user_ids(@user1.id).count.should eq(1)
      WorkSession.has_user_ids(@user2.id).count.should eq(1)
      WorkSession.has_user_ids([@user1.id,@user2.id]).count.should eq(2)
      WorkSession.has_user_ids(nil).count.should eq(0)      
    end      
     
    it "selects work_session with friends" do
      WorkSession.count.should eq(2)
      Friendship.create_reciproke_friendship(@user1,@user2) 
      WorkSession.with_friends(@user1).length.should eq(1)
      WorkSession.with_friends(@user2).length.should eq(1) 
    end   
    
    it "orders by calendar events count" do
      @user3 = FactoryGirl.create(:user)
      @calendar_event3 = FactoryGirl.create(:calendar_event, :user=>@user3, :work_session=>@work_session1)
      WorkSession.all[0].should eq(@work_session1)
      WorkSession.all[1].should eq(@work_session2)
      WorkSession.order_by_calendar_events_count[0].should eq(@work_session2)
      WorkSession.order_by_calendar_events_count[1].should eq(@work_session1)
    end
    
    it "selects by calendar events count" do
      @user3 = FactoryGirl.create(:user)
      @calendar_event3 = FactoryGirl.create(:calendar_event, :user=>@user3, :work_session=>@work_session1)
      WorkSession.this_week.events_count(2).length.should eq(1) #count doesn't work, use length      
      WorkSession.events_count(2)[0].should eq(@work_session1)
      WorkSession.events_count(1).length.should eq(1)
    end

    
  end
   
   context "with reorganization" do
     
     before(:each) do 
       @user1 = FactoryGirl.create(:user)
       @user2 = FactoryGirl.create(:user)
       @calendar_event1 = FactoryGirl.create(:calendar_event, :user=>@user1)
       @calendar_event2 = FactoryGirl.create(:calendar_event, :user=>@user2)
       @work_session1 = @calendar_event1.work_session
       @work_session2 = @calendar_event2.work_session
     end
     
     it "assigns the work_session of a work buddy when they are befriended and have the same time" do   
       WorkSession.count.should eq(2)    
       Friendship.create_reciproke_friendship(@user1,@user2)
       WorkSession.optimize_single_work_sessions(@user1)
       @calendar_event1.reload
       @calendar_event2.reload
       WorkSession.count.should eq(1)
       @calendar_event1.work_session.should eq(@calendar_event2.work_session)       
     end
     
     it "assigns the work_session of a work buddy when they are not befriended and have the same time" do   
       WorkSession.count.should eq(2)    
       WorkSession.optimize_single_work_sessions(@user1)
       WorkSession.optimize_single_work_sessions(@user2)

       @calendar_event1.reload
       @calendar_event2.reload
      # puts "ce1.ws=#{@calendar_event1.work_session.id}"
      # puts "ce2.ws=#{@calendar_event2.work_session.id}"

       WorkSession.count.should eq(1)
       @calendar_event1.work_session.should eq(@calendar_event2.work_session)       
     end  
     
     it "assigns the work_session of a work buddy when they are befriended, but don't have the same time" do   
       WorkSession.count.should eq(2)
       @calendar_event2.start_time += 1.hour    
       @work_session2.start_time += 1.hour   
       @calendar_event2.save
       @work_session2.save
       Friendship.create_reciproke_friendship(@user1,@user2)
       WorkSession.optimize_single_work_sessions(@user1)
       WorkSession.count.should eq(2)
       @calendar_event1.work_session.should_not eq(@calendar_event2.work_session)       
     end     
     
     it "finds the best work_session for a user and start_time" do 
       Friendship.create_reciproke_friendship(@user1,@user2)   
       opt_work_session = WorkSession.find_work_session(@user1,@calendar_event1.start_time)  
       opt_work_session.should eq(@work_session2) 
     end
     
     it "does find a work_session even if another user has a work session at the same time" do 
       @work_session1.delete
       opt_work_session = WorkSession.find_work_session(@user1,@calendar_event1.start_time)  
       opt_work_session.should eq(@work_session2) 
     end 
     
     it "does not find the best work_session, if friend does not have the same start_time" do 
       Friendship.create_reciproke_friendship(@user1,@user2)
       @calendar_event2.start_time += 1.hour    
       @work_session2.start_time += 1.hour  
       @calendar_event2.save
       @work_session2.save       
       @work_session1.delete   
       opt_work_session = WorkSession.find_work_session(@user1,@calendar_event1.start_time)  
       opt_work_session.should eq(nil) 
     end  
     
   #  it "splits the work_session when work buddies are not friends anymore" do
   #    new_user = FactoryGirl.create(:user_with_two_friends_and_same_events)      
   #    friend1 = new_user.friendships[0].friend
   #    friend2 = new_user.friendships[1].friend
   #    new_user.calendar_events[0].work_session.should eq(friend1.calendar_events[0].work_session)     
   #    new_user.calendar_events[0].work_session.should eq(friend2.calendar_events[0].work_session)
   #    new_user.friendships[0].destroy
   #    friend1.friendships.find_by_friend_id(new_user.id).destroy
   #    WorkSession.split_work_session_when_not_friend(new_user)
   #    WorkSession.split_work_session_when_not_friend(friend1)
   #    new_user.calendar_events[0].reload
   #    friend1.calendar_events[0].reload
   #    friend2.calendar_events[0].reload    
   #
   #    new_user.calendar_events[0].work_session.should_not eq(friend1.calendar_events[0].work_session)     
   #    new_user.calendar_events[0].work_session.should eq(friend2.calendar_events[0].work_session)
   #    
   #  end    
   # 
   #  
   end
  
end
 
 
 
 
 
 
 
 
 
 
 
   

#  
#  it "selects by user_ids" do
#    new_user = FactoryGirl.create(:user)
#    new_calendar_event = FactoryGirl.create(:calendar_event,:user=>new_user)
#    CalendarEvent.count.should eq(2)
#    CalendarEvent.has_user_ids(new_user.id).count.should eq(1)
#  end
#  
#  it "selects next event" do
#    tomorrow_at_9am = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,9)+1.day
#    event_at_9am = FactoryGirl.create(:calendar_event,:start_time=>tomorrow_at_9am) 
#    tomorrow_at_11am = tomorrow_at_9am+2.hours
#    event_at_11am = FactoryGirl.create(:calendar_event,:start_time=>tomorrow_at_11am)           
#    CalendarEvent.next.should eq(event_at_9am)
#  end
#  
#  it "selects events with foreigners for a given user" do
#    new_user = FactoryGirl.create(:user)
#    #create a calendar event for the new_user with the same work_session
#    new_calendar_event = FactoryGirl.create(:calendar_event,:user=>new_user, :work_session=>@calendar_event.work_session)
#    CalendarEvent.count.should eq(2)
#    CalendarEvent.with_foreigners(new_user).count.should eq(1)   
#    CalendarEvent.with_foreigners(@calendar_event.user).count.should eq(1)           
#  end
# 
#  it "does not selects events with friends for a given user" do
#    new_user = FactoryGirl.create(:user)
#    #create a calendar event for the new_user with the same work_session
#    new_calendar_event = FactoryGirl.create(:calendar_event,:user=>new_user, :work_session=>@calendar_event.work_session)
#    Friendship.create_reciproke_friendship(@calendar_event.user,new_user)
#    CalendarEvent.count.should eq(2)
#    CalendarEvent.with_foreigners(new_user  ).count.should eq(0)   
#    CalendarEvent.with_foreigners(@calendar_event.user).count.should eq(0)           
#  end
#end
#
#
#escribe "attributes" do
#  before(:each) do
#    @work_session = FactoryGirl.create(:work_session) 
#  end
#  
#  it "is valid with attributes start_time and room" do
#    @work_session.should be_valid
#  end
# 
#  it "is not valid without start_time" do
#    @work_session.start_time = nil
#    @work_session.should_not be_valid
#  end
#  
#  it "is not valid without a room " do
#    @work_session.room_id = nil
#    @work_session.should_not be_valid
#  end  
  

#  describe "finding of the right work session" do
#
#    # create two users: user1 and user2,
#    # create a calendar event and a work session for the user1
#    before(:each) do
#     @user1 = FactoryGirl.create(:user)
#     @user2 = FactoryGirl.create(:user)     
#
#     @user1_room = FactoryGirl.create(:room, :user=>@user1)    
#     @user1_time = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,10)+1.day
#     @user1_work_session = FactoryGirl.create(:work_session, :start_time=>@user1_time, :room=>@user1_room)
#     @user1_calendar_event = FactoryGirl.create(:calendar_event, 
#       :work_session=>@user1_work_session, :user=>@user1, :start_time=>@user1_time)
#    end
#    
#    it "finds the work session of a friend at the same time" do
#      Friendship.any_instance.stub(:update_work_sessions_after_create).and_return(nil)  
#      f1 = @user2.friendships.create(:friend => @user1)
#      f2 = @user2.inverse_friendships.create(:user_id => @user1)
#                
#      work_session = WorkSession.find_work_session(@user2, @user1_time)
#      work_session.should == @user1_work_session
#    end
#    it "finds no work session if user at the same time is no friend" do
#       work_session = WorkSession.find_work_session(@user2, @user1_time)
#       work_session.should be_nil
#    end
#    it "finds no work session if the time is different to friends work session" do
#      Friendship.any_instance.stub(:update_work_sessions_after_create).and_return(nil)  
#      f1 = @user2.friendships.create(:friend => @user1)
#      f2 = @user2.inverse_friendships.create(:user_id => @user1)
#                
#      work_session = WorkSession.find_work_session(@user2, @user1_time+1.hour)
#      work_session.should be_nil
#    end
#   
#  end


