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
      @user_hour1 = FactoryGirl.create(:user_hour)
      @group_hour = @user_hour1.group_hour
      @user_hour2 = FactoryGirl.create(:user_hour, :group_hour=>@group_hour)  
      @user_hour1.save
      @user_hour2.save
    end      
    it "has many user_hours" do
      @group_hour.user_hours.count.should eq(2)
      @group_hour.user_hours.include?(@user_hour1)
      @group_hour.user_hours.include?(@user_hour2)      
    end      
    
    it "has many users" do
      @group_hour.users.count.should eq(2)
      @group_hour.users.include?(@user_hour1.user)
      @group_hour.users.include?(@user_hour2.user)      
    end    
  end
  
  context "group_hour building" do
    before(:each) do 
      @user1 = FactoryGirl.create(:user)
      @user2 = FactoryGirl.create(:user)
      @user3 = FactoryGirl.create(:user)
      @user4 = FactoryGirl.create(:user)
      @user5 = FactoryGirl.create(:user)
      
      @user_hour1 = FactoryGirl.create(:user_hour, :user=>@user1)
      @group_hour = @user_hour1.group_hour
            
      @user_hour2 = FactoryGirl.create(:user_hour, :user=>@user2, :group_hour=>@group_hour)  
      @user_hour3 = FactoryGirl.create(:user_hour, :user=>@user3, :group_hour=>@group_hour)  
      @user_hour4 = FactoryGirl.create(:user_hour, :user=>@user4, :group_hour=>@group_hour)  
      @user_hour5 = FactoryGirl.create(:user_hour, :user=>@user5, :group_hour=>@group_hour)  
    end  
    
    it "should be valid with 5 users" do
      @group_hour.should be_valid 
      [@user_hour1,@user_hour2,@user_hour3,@user_hour4,@user_hour5].each do |user_hour|
        user_hour.should be_valid
      end
    end
    
    it "should not be valid with 6 users" do
      @user6 = FactoryGirl.create(:user)   
      @user_hour6 = FactoryGirl.create(:user_hour, :user=>@user6, :group_hour=>@group_hour)        
      @group_hour.should_not be_valid
      @user_hour6.should_not be_valid 
    end
  end
    
end
