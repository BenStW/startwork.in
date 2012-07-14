# == Schema Information
#
# Table name: user_hours
#
#  id                      :integer         not null, primary key
#  user_id                 :integer
#  start_time              :datetime
#  group_hour_id           :integer
#  appointment_id          :integer
#  accepted_appointment_id :integer
#  login_time              :datetime
#  login_count             :integer
#  created_at              :datetime        not null
#  updated_at              :datetime        not null
#

require 'spec_helper'

describe UserHour do
  context "when created" do
    before(:each) do 
      appointment = FactoryGirl.create(:appointment)
      @user_hour = appointment.user_hours.first
    end
    
    it "should be valid with attributes from the factory" do
      @user_hour.should be_valid
    end

    it "should not be valid without user" do
      @user_hour.user_id = nil
      @user_hour.should_not be_valid
    end    
    
    it "should not be valid without appointment_id" do
      @user_hour.appointment_id = nil
      @user_hour.should_not be_valid
    end
    
    it "should not be valid without start_time" do
      @user_hour.start_time = nil
      @user_hour.should_not be_valid
    end    
    
    it "should not be valid without group_hour" do
      @user_hour.group_hour = nil
      @user_hour.should be_valid
      @user_hour.group_hour.should_not be_nil
    end
    
    it "should raise an error when trying to create an user_hour at the  same time an user_hour already exists" do
      user=@user_hour.user
      appointment=@user_hour.appointment
      new_user_hour = UserHour.new(:user=>user,:appointment=>appointment, :start_time=>@user_hour.start_time)
      expect {
        new_user_hour.valid?
       }.to raise_error
    end
    
    it "should raise an error when trying to create an user_hour before the time of the appointment" do
       user=@user_hour.user
       appointment=@user_hour.appointment

      new_user_hour = UserHour.new(:user=>user,:appointment=>appointment, :start_time=>@user_hour.start_time-1.hour)
      expect {
         new_user_hour.valid?
       }.to raise_error     
    end
    
    it "should raise an error when trying to create an user_hour after the time of the appointment" do
       user=@user_hour.user
       appointment=@user_hour.appointment

      new_user_hour = UserHour.new(:user=>user,:appointment=>appointment, :start_time=>@user_hour.start_time+2.hour)
      expect {
         new_user_hour.valid?
       }.to raise_error     
    end    
  end

    
        
  context "when destroyed" do
   it "destroys the group_hour when user_hour is destroyed and no other user_hour in group" do
      appointment = FactoryGirl.create(:appointment)
      user_hour = appointment.user_hours.first     
      expect { user_hour.destroy }.to change(GroupHour, :count).by(-1)
    end  

    it "does not destroy the group_hour when user_hour is destroyed, but an other user_hour in group" do
      user = FactoryGirl.create(:user)
      appointment = FactoryGirl.create(:appointment, :user=>user)
      new_user = FactoryGirl.create(:user)
      recipient_appointment = FactoryGirl.create(:recipient_appointment, :user=>new_user, :appointment=>appointment)
      new_appointment = Appointment.accept_received_appointment(new_user, appointment)
      user_hour = appointment.user_hours.first
      #GroupHour.all.each do |g| puts "id=#{g.id} (#{g.user_hours.count}u)" end
      expect { user_hour.destroy }.to change(GroupHour, :count).by(0)
      #GroupHour.all.each do |g| puts "id=#{g.id} (#{g.user_hours.count}u)" end
      
    end      
    
  end
  
  context "class method next" do
    it "selects next user_hour" do
      tomorrow_at_9am = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,9)+1.day
      tomorrow_at_11am = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,11)+1.day
      
      user = FactoryGirl.create(:user)
      appointment_11am = FactoryGirl.create(:appointment,:start_time=>tomorrow_at_11am, :end_time=>tomorrow_at_11am+1.hour,:user=>user)
      appointment_9am = FactoryGirl.create(:appointment,:start_time=>tomorrow_at_9am, :end_time=>tomorrow_at_9am+1.hour,:user=>user)
            
      UserHour.next.should eq(appointment_9am.user_hours.first)
    end
  end
  
  context "class method current" do
     before(:each) do 
       @appointment = FactoryGirl.create(:appointment)
       @user_hour_at_10 = @appointment.user_hours.first
       @user_hour_at_11 = @appointment.user_hours.last
       @tomorrow_10am = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,10)+1.day       
     end

      it "selects next user_hour starting 5 minutes after now" do
        DateTime.stub(:current).and_return(@tomorrow_10am+5.minutes)
        UserHour.next.should eq(@user_hour_at_10)
      end

      it "does not select next user_hour starting 65 minutes ago" do
        DateTime.stub(:current).and_return(@tomorrow_10am+65.minutes)
        UserHour.next.should  eq(@user_hour_at_11)
      end 

      it "does not select next user_hour starting 65 minutes ago, no following user_hour" do
        DateTime.stub(:current).and_return(@tomorrow_10am + 65.minutes)
        @appointment.end_time = @tomorrow_10am+1.hour
        @appointment.save
        UserHour.current.should be_nil
      end

      it "selects current user_hour 3 minutes before start" do
        DateTime.stub(:current).and_return(@tomorrow_10am - 3.minutes)
        UserHour.current.should_not be_nil
      end

      it "does not select current user_hour 6 minutes before start" do
        DateTime.stub(:current).and_return(@tomorrow_10am - 6.minutes)
        UserHour.current.should be_nil
      end   

      it "does select current user_hour 56 minutes after start" do
        DateTime.stub(:current).and_return(@tomorrow_10am +56.minutes)
        UserHour.current.should eq(@user_hour_at_10)
      end    
  end
  
  context "when storing the logins" do
    before(:each) do 
      appointment = FactoryGirl.create(:appointment)
      @user_hour = appointment.user_hours.first
    end    
    it "stores the current time as login_time when login_time is empty" do
      @user_hour.login_time.should be_nil
      @user_hour.store_login
      @user_hour.login_time.should_not be_nil
    end
    it "does not overwrite the time if its already populated" do
      tomorrow_at_11am = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,9)+1.day     
      DateTime.stub(:current).and_return(tomorrow_at_11am)
      @user_hour.store_login
      tomorrow_at_9_15am = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,9)+1.day+15.minutes
      @user_hour.store_login
      @user_hour.login_time.should eq(tomorrow_at_11am)     
    end
    it "counts the logins" do
      @user_hour.login_count.should be_nil
      @user_hour.store_login
      @user_hour.login_count.should eq(1)
      @user_hour.store_login
      @user_hour.login_count.should eq(2)
    end
    it "filters the non_logged_in hours" do
      UserHour.logged_in.should eq([])      
      UserHour.not_logged_in.should eq(UserHour.all)
    end
    it "filters the logged_in hours" do
      @user_hour.store_login
      UserHour.logged_in.should eq([@user_hour])
      UserHour.not_logged_in.should eq(UserHour.all-[@user_hour])
    end
    
    
  end  
  
  
end
