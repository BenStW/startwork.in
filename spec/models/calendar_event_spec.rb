# == Schema Information
#
# Table name: calendar_events
#
#  id              :integer         not null, primary key
#  user_id         :integer
#  start_time      :datetime
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  work_session_id :integer
#  login_time      :datetime
#  login_count     :integer
#

require 'spec_helper'

describe CalendarEvent do

   before(:each) do
    @calendar_event = FactoryGirl.create(:calendar_event)
   end
  
  context "when created" do
    
    it "should be valid with attributes from the factory" do
      @calendar_event.should be_valid
    end
 
    it "should not be valid without start_time" do
      @calendar_event.start_time = nil
      @calendar_event.should_not be_valid
    end
      
    it "should not be valid without user" do
      @calendar_event.user = nil
      @calendar_event.should_not be_valid  
    end   
    
    it "should not be valid without worksession" do
      @calendar_event.work_session = nil
      @calendar_event.should_not be_valid  
    end    
 end
 
 context "with class methods" do
   
    it "selects events of this week" do
      CalendarEvent.this_week.count.should eq(1)
    end
    
    it "does not select events of last week" do
      yesterday = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,10)-1.day
      last_calendar_event = FactoryGirl.create(:calendar_event,:start_time=>yesterday)
      CalendarEvent.count.should eq(2)
      CalendarEvent.this_week.count.should eq(1)
    end
    
    it "orders by start_time" do
      tomorrow_at_9am = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,9)+1.day
      new_calendar_event = FactoryGirl.create(:calendar_event,:start_time=>tomorrow_at_9am)
      CalendarEvent.all[0].should eq(@calendar_event)
      CalendarEvent.all[1].should eq(new_calendar_event)
      CalendarEvent.order_by_start_time[0].should eq(new_calendar_event)
      CalendarEvent.order_by_start_time[1].should eq(@calendar_event)   
    end   
    
    it "selects by user_ids" do
      new_user = FactoryGirl.create(:user)
      new_calendar_event = FactoryGirl.create(:calendar_event,:user=>new_user)
      CalendarEvent.count.should eq(2)
      CalendarEvent.has_user_ids(new_user.id).count.should eq(1)
      CalendarEvent.has_user_ids([@calendar_event.user.id,new_user.id]).count.should eq(2)      
      CalendarEvent.has_user_ids(nil).count.should eq(0)
    end
    
    it "selects next event" do
      tomorrow_at_9am = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,9)+1.day
      event_at_9am = FactoryGirl.create(:calendar_event,:start_time=>tomorrow_at_9am) 
      tomorrow_at_11am = tomorrow_at_9am+2.hours
      event_at_11am = FactoryGirl.create(:calendar_event,:start_time=>tomorrow_at_11am)           
      CalendarEvent.next.should eq(event_at_9am)
    end
    

    
    it "selects next event starting 5 minutes after now" do
      tomorrow_8am = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,8)+1.day
      DateTime.stub(:current).and_return(tomorrow_8am+5.minutes)
      event_at_8am = FactoryGirl.create(:calendar_event,:start_time=>tomorrow_8am) 
      CalendarEvent.next.should eq(event_at_8am)
    end
    
    it "does not select next event starting 65 minutes ago" do
      tomorrow_8am = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,8)+1.day
      DateTime.stub(:current).and_return(tomorrow_8am+65.minutes)
      event_at_8am = FactoryGirl.create(:calendar_event,:start_time=>tomorrow_8am) 
      CalendarEvent.next.start_time.should > tomorrow_8am
    end 
    
    it "selects current event" do
      tomorrow_at_9am = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,9)+1.day
      event_at_9am = FactoryGirl.create(:calendar_event,:start_time=>tomorrow_at_9am) 
      DateTime.stub(:current).and_return(tomorrow_at_9am + 5.minutes)
      CalendarEvent.current.should_not be_nil
    end
    
    it "selects current event 3 minutes before start" do
      tomorrow_at_9am = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,9)+1.day
      event_at_9am = FactoryGirl.create(:calendar_event,:start_time=>tomorrow_at_9am) 
      DateTime.stub(:current).and_return(tomorrow_at_9am - 3.minutes)
      CalendarEvent.current.should_not be_nil
    end
    
    it "does not select current event 6 minutes before start" do
      tomorrow_at_9am = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,9)+1.day
      event_at_9am = FactoryGirl.create(:calendar_event,:start_time=>tomorrow_at_9am) 
      DateTime.stub(:current).and_return(tomorrow_at_9am - 6.minutes)
      CalendarEvent.current.should be_nil
    end   
    
    it "does select current event 56 minutes after start" do
      tomorrow_at_9am = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,9)+1.day
      event_at_9am = FactoryGirl.create(:calendar_event,:start_time=>tomorrow_at_9am) 
      DateTime.stub(:current).and_return(tomorrow_at_9am +56.minutes)
      CalendarEvent.current.should eq(event_at_9am)
    end               
    
    it "selects events with foreigners for a given user" do
      new_user = FactoryGirl.create(:user)
      #create a calendar event for the new_user with the same work_session
      new_calendar_event = FactoryGirl.create(:calendar_event,:user=>new_user, :work_session=>@calendar_event.work_session)
      CalendarEvent.count.should eq(2)
      CalendarEvent.with_foreigners(new_user).count.should eq(1)   
      CalendarEvent.with_foreigners(@calendar_event.user).count.should eq(1)           
    end
   
    it "does not selects events with friends for a given user" do
      new_user = FactoryGirl.create(:user)
      #create a calendar event for the new_user with the same work_session
      new_calendar_event = FactoryGirl.create(:calendar_event,:user=>new_user, :work_session=>@calendar_event.work_session)
      Friendship.create_reciproke_friendship(@calendar_event.user,new_user)
      CalendarEvent.count.should eq(2)
      CalendarEvent.with_foreigners(new_user  ).count.should eq(0)   
      CalendarEvent.with_foreigners(@calendar_event.user).count.should eq(0)           
    end    
  end

 context "with work_session" do
   
   it "should build a work_session" do
     @calendar_event.work_session.delete
     @calendar_event.work_session = nil
     @calendar_event.should_not be_valid     
     @calendar_event.find_or_build_work_session
     @calendar_event.save
     @calendar_event.work_session.should_not be_nil
     @calendar_event.should be_valid
   end
   
   it "should assign an existing work_session" do    
     @calendar_event.work_session.delete      
     @calendar_event.work_session = nil
     
     new_work_session = FactoryGirl.create(:work_session)
     WorkSession.stub(:find_work_session).and_return(new_work_session)     
     @calendar_event.find_or_build_work_session
     @calendar_event.should be_valid
     @calendar_event.work_session.should eq(new_work_session)
   end
 end
 
 context "when storing the logins" do
   it "stores the current time when no time given" do
     @calendar_event.store_login
     @calendar_event.login_time.should_not be_nil
   end
   it "does not overwrite the time if its already populated" do
     tomorrow_at_9am = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,9)+1.day     
     DateTime.stub(:current).and_return(tomorrow_at_9am)
     @calendar_event.store_login
     tomorrow_at_9_15am = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,9)+1.day+15.minutes
     @calendar_event.store_login
     @calendar_event.login_time.should eq(tomorrow_at_9am)     
   end
   it "counts the logins" do
     @calendar_event.login_count.should be_nil
     @calendar_event.store_login
     @calendar_event.login_count.should eq(1)
     @calendar_event.store_login
     @calendar_event.login_count.should eq(2)
   end
   
 end
 
#context "merges calendar events to display on main page" do
#  it "shows the end_time" do
#    @calendar_event
#    puts @calendar_event.to_yaml
#    puts @calendar_event.end_time
#  end
# end 
 
 end

