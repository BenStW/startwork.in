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
  
  before { @user = FactoryGirl.create(:user)
  #  puts "********* user: tokbox_session_id = #{@user.room.tokbox_session_id}"
  #  @room = FactoryGirl.create(:room)
  #  puts "********* room: tokbox_session_id = #{@room.tokbox_session_id}"
    }
     
  
   subject { @user }
  
  describe "when first name is not present" do
      before { @user.first_name = " " }
      it { should_not be_valid }
  end
  
  describe "when last name is not present" do
      before { @user.last_name = " " }
      it { should_not be_valid }
  end

  describe "when first name is too long" do
     before { @user.first_name = "a" * 51 }
     it { should_not be_valid }
   end
   describe "when email format is invalid" do
     invalid_addresses =  %w[user@foo,com user_at_foo.org example.user@foo.]
     invalid_addresses.each do |invalid_address|
       before { @user.email = invalid_address }
       it { should_not be_valid }
     end
   end
   describe "when email format is valid" do
      valid_addresses = %w[user@foo.com A_USER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      valid_addresses.each do |valid_address|
       before { @user.email = valid_address }
        it { 
          should be_valid
          }
      end
    end
  
 #  it "should not be valid with existing name" do
 #    user_with_same_name = FactoryGirl.build(:user, :first_name => @user.first_name)
 #    user_with_same_name.should_not be_valid
 #  end

    it "should not be valid with existing email" do  
      user_with_same_email = FactoryGirl.build(:user, :email => @user.email)
      user_with_same_email.should_not be_valid
    end   

    describe "when password is not present" do
      before { @user.password = @user.password_confirmation = " " }
      it { should_not be_valid }
    end
    describe "when password doesn't match confirmation" do
      before { @user.password_confirmation = "mismatch" }
      it { should_not be_valid }
    end

   it "creates and closes a connection" do
        should_not be_open_connections
        @user.start_connection
        should be_open_connections
        @user.end_connection
        should_not be_open_connections        
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


   it "shows all events of this week" do
     number_of_times = @user.all_events_of_this_week.length 
     t = DateTime.current
     start_time_yesterday = DateTime.new(t.year, t.month,t.day,14) - 1.day
     e1 = @user.calendar_events.create(start_time:start_time_yesterday)

     start_time_tomorrow = DateTime.new(t.year, t.month,t.day,14) + 1.day
     e2 = @user.calendar_events.create(start_time:start_time_tomorrow)

     new_number_of_times = @user.all_events_of_this_week.length
     diff_number_of_times = new_number_of_times - number_of_times
     diff_number_of_times.should eq(1)       
   end

   it "has friendships with friends" do
     user_steffi = FactoryGirl.create(:user, :first_name => "steffi", :last_name => "Rothenberger")
     friendship = @user.friendships.build(:friend_id => user_steffi.id)
     @user.friendships.first.friend.should eql(user_steffi)
     @user.save
     @user.friends.first.should eql(user_steffi)
   end

  
  it "has inverse friendships with friends" do
     user_steffi = FactoryGirl.create(:user, :first_name => "steffi", :last_name => "Rothenberger")
    friendship = @user.friendships.build(:friend_id => user_steffi.id)
    @user.save    
    user_steffi.inverse_friendships.first.user.should eql(@user)
    user_steffi.inverse_friends.first.should eql(@user)
  end
  
  it "shows all friends events of this week" do
    user = FactoryGirl.create(:user_with_two_friends_and_same_events)
    events =  user.all_friends_events_of_this_week
    events.count.should eql(1)
  end
end
