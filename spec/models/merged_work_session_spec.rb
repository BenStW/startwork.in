require 'spec_helper'

describe MergedWorkSession do
  

  context "merge_continuing_work_sessions, only one user" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @tomorrow_10_am = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,10)+1.day
      @calendar_event_at_10am = FactoryGirl.create(:calendar_event, :user=>@user)
      @calendar_event_at_11am = FactoryGirl.create(:calendar_event, :user=>@user, :start_time=>@tomorrow_10_am+1.hour)
      @calendar_event_at_13am = FactoryGirl.create(:calendar_event, :user=>@user, :start_time=>@tomorrow_10_am+3.hour)
      @calendar_event_at_15am = FactoryGirl.create(:calendar_event, :user=>@user, :start_time=>@tomorrow_10_am+5.hour)
      @calendar_event_at_16am = FactoryGirl.create(:calendar_event, :user=>@user, :start_time=>@tomorrow_10_am+6.hour)      

      @work_session_at_10am = @calendar_event_at_10am.work_session
      @work_session_at_11am = @calendar_event_at_11am.work_session
      @work_session_at_13am = @calendar_event_at_13am.work_session
      @work_session_at_15am = @calendar_event_at_15am.work_session
      @work_session_at_16am = @calendar_event_at_16am.work_session
    end
    
    
    it "merges two WorkSessions (10,11) into one mergedWorkSession (10-12)" do
       work_sessions = [@work_session_at_11am,@work_session_at_10am]
       array = MergedWorkSession.merge_continuing_work_sessions(work_sessions,@user)
       array.length.should eq(1)
       array[0].start_time.should eq(@work_session_at_10am.start_time)
       array[0].end_time.should eq(@tomorrow_10_am+2.hour)
    end

    it "merges 10,11,13 to 10-12 and 13-14" do
       work_sessions = [@work_session_at_10am,@work_session_at_11am, @work_session_at_13am]
       array = MergedWorkSession.merge_continuing_work_sessions(work_sessions,@user)
       array.length.should eq(2)
       array[0].start_time.should eq(@tomorrow_10_am)
       array[0].end_time.should eq(@tomorrow_10_am+2.hour)
       array[1].start_time.should eq(@tomorrow_10_am+3.hour)
       array[1].end_time.should eq(@tomorrow_10_am+4.hour)
    end
    
    it "merges 10,11,13,15,16 to 10-12, 13-14, 15-17" do
      work_sessions = [@work_session_at_10am,@work_session_at_11am, @work_session_at_13am, @work_session_at_15am, @work_session_at_16am]
      array = MergedWorkSession.merge_continuing_work_sessions(work_sessions,@user)
      array.length.should eq(3)
      array[0].start_time.should eq(@tomorrow_10_am)
      array[0].end_time.should eq(@tomorrow_10_am+2.hour)
      array[1].start_time.should eq(@tomorrow_10_am+3.hour)
      array[1].end_time.should eq(@tomorrow_10_am+4.hour)     
      array[2].start_time.should eq(@tomorrow_10_am+5.hour)
      array[2].end_time.should eq(@tomorrow_10_am+7.hour)     
    end
    
    it "merges 10 to 10-11" do
      work_sessions = [@work_session_at_10am]
      array = MergedWorkSession.merge_continuing_work_sessions(work_sessions,@user)
      array.length.should eq(1)
      array[0].start_time.should eq(@tomorrow_10_am)
      array[0].end_time.should eq(@tomorrow_10_am+1.hour)
    end      
    
    it "merges empty array to nil" do
      array = MergedWorkSession.merge_continuing_work_sessions [],@user
      array.length.should eq(0)
    end
    
  end
  
  context "merge_continuing_work_sessions, one user with two friends and a fourth user" do
    before(:each) do
      @tomorrow_10_am = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,10)+1.day
      
      @user = FactoryGirl.create(:user)
      @friend1 = FactoryGirl.create(:user)
      @friend2 = FactoryGirl.create(:user)
      @third_user = FactoryGirl.create(:user)
      
      Friendship.create_reciproke_friendship(@user,@friend1)
      Friendship.create_reciproke_friendship(@user,@friend2)
            
      @user_calendar_event_at_10am = FactoryGirl.create(:calendar_event, :user=>@user, :start_time=>@tomorrow_10_am)      
      @user_calendar_event_at_11am = FactoryGirl.create(:calendar_event, :user=>@user, :start_time=>@tomorrow_10_am+1.hour)
      @user_calendar_event_at_13am = FactoryGirl.create(:calendar_event, :user=>@user, :start_time=>@tomorrow_10_am+3.hour)
      @user_calendar_event_at_15am = FactoryGirl.create(:calendar_event, :user=>@user, :start_time=>@tomorrow_10_am+5.hour)
      @user_calendar_event_at_16am = FactoryGirl.create(:calendar_event, :user=>@user, :start_time=>@tomorrow_10_am+6.hour)      

      @user_work_session_at_10am = @user_calendar_event_at_10am.work_session
      @user_work_session_at_11am = @user_calendar_event_at_11am.work_session
      @user_work_session_at_13am = @user_calendar_event_at_13am.work_session
      @user_work_session_at_15am = @user_calendar_event_at_15am.work_session
      @user_work_session_at_16am = @user_calendar_event_at_16am.work_session

      @friend1_calendar_event_at_10am = FactoryGirl.create(:calendar_event, :user=>@friend1, :start_time=>@tomorrow_10_am, :work_session=>@user_work_session_at_10am)    
      @friend1_calendar_event_at_11am = FactoryGirl.create(:calendar_event, :user=>@friend1, :start_time=>@tomorrow_10_am+1.hour, :work_session=>@user_work_session_at_11am)
      @friend1_calendar_event_at_12am = FactoryGirl.create(:calendar_event, :user=>@friend1, :start_time=>@tomorrow_10_am+2.hour)
      @friend1_calendar_event_at_15am = FactoryGirl.create(:calendar_event, :user=>@friend1, :start_time=>@tomorrow_10_am+5.hour, :work_session=>@user_work_session_at_15am)
      @friend1_calendar_event_at_16am = FactoryGirl.create(:calendar_event, :user=>@friend1, :start_time=>@tomorrow_10_am+6.hour, :work_session=>@user_work_session_at_16am)

      @friend2_calendar_event_at_11am = FactoryGirl.create(:calendar_event, :user=>@friend2, :start_time=>@tomorrow_10_am+1.hour, :work_session=>@user_work_session_at_11am)    
      @friend2_calendar_event_at_12am = FactoryGirl.create(:calendar_event, :user=>@friend2, :start_time=>@tomorrow_10_am+2.hour)
      @friend2_calendar_event_at_13am = FactoryGirl.create(:calendar_event, :user=>@friend2, :start_time=>@tomorrow_10_am+3.hour, :work_session=>@user_work_session_at_13am)

      @third_user_calendar_event_at_10am = FactoryGirl.create(:calendar_event, :user=>@third_user, :start_time=>@tomorrow_10_am, :work_session=>@user_work_session_at_10am)
      @third_user_calendar_event_at_11am = FactoryGirl.create(:calendar_event, :user=>@third_user, :start_time=>@tomorrow_10_am+1.hour, :work_session=>@user_work_session_at_11am)
      @third_user_calendar_event_at_12am = FactoryGirl.create(:calendar_event, :user=>@third_user, :start_time=>@tomorrow_10_am+2.hour)
      @third_user_calendar_event_at_13am = FactoryGirl.create(:calendar_event, :user=>@third_user, :start_time=>@tomorrow_10_am+3.hour, :work_session=>@user_work_session_at_13am)
    end
     
    it "merges 10,11,13,15,16 to 10-12, 13-14, 15-17" do
       work_sessions = [
          @user_work_session_at_10am,
          @user_work_session_at_11am,
          @user_work_session_at_13am,
          @user_work_session_at_15am,
          @user_work_session_at_16am
          ]
       array = MergedWorkSession.merge_continuing_work_sessions(work_sessions,@user)
       array.length.should eq(3)
       array[0].start_time.should eq(@tomorrow_10_am)
       array[0].end_time.should eq(@tomorrow_10_am+2.hour)
       array[0].friends.length.should eq(2)
       array[1].start_time.should eq(@tomorrow_10_am+3.hour)
       array[1].end_time.should eq(@tomorrow_10_am+4.hour)     
       array[1].friends.length.should eq(1)
       array[2].start_time.should eq(@tomorrow_10_am+5.hour)
       array[2].end_time.should eq(@tomorrow_10_am+7.hour)       
       array[2].friends.length.should eq(1)  
    end
    
    it "merges 10,11,13,15,16 to 10-12, 13-14, 15-17 with equal friends" do
      work_sessions = [
         @user_work_session_at_10am,
         @user_work_session_at_11am,
         @user_work_session_at_13am,
         @user_work_session_at_15am,
         @user_work_session_at_16am
         ]
      array = MergedWorkSession.merge_continuing_work_sessions(work_sessions,@user,true) 
      array[0].start_time.should eq(@tomorrow_10_am)
      array[0].end_time.should eq(@tomorrow_10_am+1.hour)
      array[0].friends[0].should eq(@friend1)
      array[1].start_time.should eq(@tomorrow_10_am+1.hour)
      array[1].end_time.should eq(@tomorrow_10_am+2.hour)
      array[1].friends.length.should eq(2)
      array[2].start_time.should eq(@tomorrow_10_am+3.hour)
      array[2].end_time.should eq(@tomorrow_10_am+4.hour)
      array[2].friends[0].should eq(@friend2)   
      array[3].start_time.should eq(@tomorrow_10_am+5.hour)
      array[3].end_time.should eq(@tomorrow_10_am+7.hour)
      array[3].friends[0].should eq(@friend1)     
    end

  end
end
