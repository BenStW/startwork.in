# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(255)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  referer                :string(255)
#  first_name             :string(255)
#  last_name              :string(255)
#

require 'spec_helper'

describe User do
  
  before { @user = FactoryGirl.create(:user)  }
  
#  subject { @user }
  
  context "when created" do
    
    it "should be valid with attributes from factory" do
      @user.should be_valid
    end
    
    it "should not be valid when first name is blank" do
      @user.first_name = " "
      @user.should_not be_valid
    end

    it "should not be valid when last name is blank" do
      @user.last_name = " "
      @user.should_not be_valid
    end   
    
    it "should not be valid when first name is too long" do
      @user.first_name = "a" * 31 
      @user.should_not be_valid
    end   
    
    it "should not be valid when last name is too long" do
      @user.last_name = "a" * 31 
      @user.should_not be_valid
    end      
    
    it "should not be valid when email format is invalid" do
      invalid_addresses =  %w[user@foo,com user_at_foo.org example.user@foo.]
      invalid_addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end    
    end
    
    it "should be valid when email format is valid" do
      valid_addresses = %w[user@foo.com A_USER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      valid_addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end    
    end
    
    it "should be valid with existing name" do
      user_with_same_name = FactoryGirl.build(:user, :first_name => @user.first_name,:last_name => @user.last_name)
      user_with_same_name.should be_valid
    end
    
    it "should not be valid with existing email" do  
      user_with_same_email = FactoryGirl.build(:user, :email => @user.email)
      user_with_same_email.should_not be_valid
    end
    
    it "should not be valid without password " do
      @user.password = @user.password_confirmation = " "
      @user.should_not be_valid
    end
    
    it "should not be valid when password doesn't match confirmation" do
      @user.password_confirmation = "mismatch"
      @user.should_not be_valid 
    end
    
  # it "should not be valid without a room" do
  #   @user.room = nil
  #   @user.should_not be_valid
  # end
    
    it "should concatenate first and last name by method name" do
       name = "#{@user.first_name} #{@user.last_name}"
       @user.name.should eq(name)
    end
  end
  
  context "handles connections" do
    it "starts a connection" do
      @user.connections.count.should eq(0)
      @user.start_connection
      @user.connections.count.should eq(1)   
    end
    
    it "has no open connections when no connection was started" do
      @user.should_not be_open_connections
    end
    
    it "has open connections when a connection was started" do
      @user.start_connection      
      @user.should be_open_connections
    end
    
    it "closes a connection" do
      @user.start_connection
      @user.end_connection
    end   
    
    it "has no open connections when connection was closed" do
      @user.start_connection  
      @user.end_connection
      @user.should_not be_open_connections
    end 
    
    it "doesn't create two connections when connection was started twice" do
       @user.start_connection
       @user.start_connection
       @user.connections.count.should eq(1)  
    end
    
    it "calculates the duration of all connections" do
      conn1 = @user.start_connection
      conn1.stub(:end_time).and_return(conn1.start_time + 5.minutes)
      @user.stub(:open_connections?).and_return(false)
     
      conn2 = @user.start_connection
      conn2.stub(:end_time).and_return(conn2.start_time + 5.minutes)
      @user.stub(:open_connections?).and_return(false)
     
      @user.duration_of_connections.should == 10      
    end
  
  end
end
