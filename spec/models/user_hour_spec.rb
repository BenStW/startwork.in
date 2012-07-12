# == Schema Information
#
# Table name: user_hours
#
#  id                      :integer         not null, primary key
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
      @user_hour = FactoryGirl.create(:user_hour)
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
  end

    
        
  context "when destroyed" do
   it "destroys the group_hour when user_hour is destroyed and no other user_hour in group" do
      @user_hour = FactoryGirl.create(:user_hour)
      expect { @user_hour.destroy }.to change(GroupHour, :count).by(-1)
    end  

    it "does not destroy the group_hour when user_hour is destroyed, but an other user_hour in group" do
      user = FactoryGirl.create(:user)
      appointment = FactoryGirl.create(:appointment, :user=>user)
      new_user = FactoryGirl.create(:user)
      new_appointment = Appointment.accept_received_appointment(new_user, appointment)
      user_hour = appointment.user_hours.first
      #GroupHour.all.each do |g| puts "id=#{g.id} (#{g.user_hours.count}u)" end
      expect { user_hour.destroy }.to change(GroupHour, :count).by(0)
      #GroupHour.all.each do |g| puts "id=#{g.id} (#{g.user_hours.count}u)" end
      
    end      
    
  end
  
  context "when storing the logins" do
    before(:each) do 
      @user_hour = FactoryGirl.create(:user_hour)
    end    
    it "stores the current time as login_time when login_time is empty" do
      @user_hour.login_time.should be_nil
      @user_hour.store_login
      @user_hour.login_time.should_not be_nil
    end
    it "does not overwrite the time if its already populated" do
      tomorrow_at_9am = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,9)+1.day     
      DateTime.stub(:current).and_return(tomorrow_at_9am)
      @user_hour.store_login
      tomorrow_at_9_15am = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,9)+1.day+15.minutes
      @user_hour.store_login
      @user_hour.login_time.should eq(tomorrow_at_9am)     
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
