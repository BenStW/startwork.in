# == Schema Information
#
# Table name: group_hours
#
#  id                :integer         not null, primary key
#  start_time        :datetime
#  tokbox_session_id :string(255)
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#

require 'spec_helper'

describe GroupHour do
  context "attributes when created" do
    before(:each) do 
      @group_hour = FactoryGirl.create(:group_hour)
    end
    
    it "should be valid with attributes from the factory" do
      @group_hour.should be_valid
    end
    
    it "should not be valid without tokbox_session_id" do
      @group_hour.tokbox_session_id = nil
      @group_hour.should_not be_valid
    end
    
    it "should not be valid without start_time" do
      @group_hour.start_time = nil
      @group_hour.should_not be_valid
    end
  end  
  
  context "basic associations" do
    before(:each) do 
      @user_a = FactoryGirl.create(:user)
      appointment_a = FactoryGirl.create(:appointment,:user=>@user_a)
      @user_hour_a = appointment_a.user_hours.first
      @group_hour = @user_hour_a.group_hour
      
      @user_b = FactoryGirl.create(:user)
      appointment_a.receive_and_accept(@user_b)

      @user_hour_b = @user_b.user_hours.first
    end      
    it "has many user_hours" do
      @group_hour.user_hours.count.should eq(2)
      @group_hour.user_hours.include?(@user_hour_a).should eq(true)
      @group_hour.user_hours.include?(@user_hour_b).should eq(true)
    end      
    
    it "has many users" do
      @group_hour.users.count.should eq(2)
    end    
  end
  
  context "class method current_logged_in_except_user" do
    before(:each) do       
      #ActiveRecord::Base.logger = Logger.new(STDOUT) if defined?(ActiveRecord::Base)
      @my_user = FactoryGirl.create(:user)         
      @user_a = FactoryGirl.create(:user)    
      @user_b = FactoryGirl.create(:user)    
      appointment_a = FactoryGirl.create(:appointment, :user=>@user_a)
      my_appointment = FactoryGirl.create(:appointment, :user=>@my_user)
      appointment_a.receive_and_accept(@user_b)
      DateTime.stub(:current).and_return(appointment_a.start_time+5.minutes)      
    end
    
    it "finds no group_hours, if nobody has logged_in" do
      current_logged_in = GroupHour.get_potential_foreign_groups(@my_user)
      current_logged_in.count.should eq(0)
    end
    
    it "finds the group_hour, if user_a has logged_in" do
      user_hour_a_first = @user_a.user_hours.first
      user_hour_a_first.store_login
      user_hour_a_first.reload
      current_logged_in = GroupHour.get_potential_foreign_groups(@my_user)
      current_logged_in.count.should eq(1)
      current_logged_in.first.id.should eq(user_hour_a_first.group_hour.id)
    end
    it "finds the group_hour, if a user_b has logged_in at 11:00" do
      tomorrow_11_05am = DateTime.current+60.minutes
      DateTime.stub(:current).and_return(tomorrow_11_05am)            
      user_hour_a_first = @user_a.user_hours.first
      user_hour_a_first.store_login
      user_hour_b_last = @user_b.user_hours.last
      user_hour_b_last.store_login 
      current_logged_in = GroupHour.get_potential_foreign_groups(@my_user)
      current_logged_in.count.should eq(1)
      current_logged_in.first.id.should eq(user_hour_b_last.group_hour.id)     
    end
    it "stores the number of logged_in per group_hour" do
      user_hour_a_first = @user_a.user_hours.first
      user_hour_a_first.store_login
      user_hour_b_first = @user_b.user_hours.first
      user_hour_b_first.store_login
      
      current_logged_in = GroupHour.get_potential_foreign_groups(@my_user)
      current_logged_in.count.should eq(1)
      current_logged_in.first.logged_in_count.to_i.should eq(2)            
    end
    it "does not find the own group_hour" do
      my_user_hour_first = @my_user.user_hours.first
      user_hour_a_first = @user_a.user_hours.first
      user_hour_a_first.store_login
      my_user_hour_first.store_login
      current_logged_in = GroupHour.get_potential_foreign_groups(@my_user)
      current_logged_in.count.should eq(1)
      current_logged_in.first.id.should eq(user_hour_a_first.group_hour.id)
    end    
  end
  
  context "group_hour building" do
    before(:each) do 
      @user1 = FactoryGirl.create(:user)
      @user2 = FactoryGirl.create(:user)
      @user3 = FactoryGirl.create(:user)
      @user4 = FactoryGirl.create(:user)
      @user5 = FactoryGirl.create(:user)
      
      @appointment1 = FactoryGirl.create(:appointment, :user=>@user1)
      @appointment1.receive_and_accept(@user2)
      @appointment1.receive_and_accept(@user3)
      @appointment1.receive_and_accept(@user4)
      @appointment1.receive_and_accept(@user5)
    end  
    
    it "should be valid with 5 users" do
      @appointment1.group_hours.each do |group_hour|
        group_hour.should be_valid
      end
    end
    
    it "should not be valid with 6 users" do
      @user6 = FactoryGirl.create(:user)   
      @appointment1.receive_and_accept(@user6)
      @user6.user_hours.first.group_hour.should_not be_valid
    end
  end
    
end
