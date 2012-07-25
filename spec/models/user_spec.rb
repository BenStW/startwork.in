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
#  fb_ui                  :string(255)
#  registered             :boolean
#  comment                :string(255)
#

require 'spec_helper'

describe User do
  
  before(:each) do 
    @user = FactoryGirl.create(:user)  
  end
  
  
  context "when created" do
    
    it "should be valid with attributes from factory" do
      @user.should be_valid
    end
    
    it "should not be valid when first name is blank" do
      @user.first_name = " "
      @user.should_not be_valid
    end 
    
    it "should not be valid when first name is too long" do
      @user.first_name = "a" * 51 
      @user.should_not be_valid
    end   
    
    it "should not be valid when last name is too long" do
      @user.last_name = "a" * 51 
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
    
    it "should not be valid without facebook unique identifier" do
      @user.fb_ui = nil
      @user.should_not be_valid
    end

    it "should concatenate first and last name by method name" do
       name = "#{@user.first_name} #{@user.last_name}"
       @user.name.should eq(name)
    end
    

  end
  
  context "create_appointment_now" do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end
    it "should create an appointment" do
      expect {        
        @user.create_appointment_now
      }.to change(Appointment,:count).by(1)
    end   
    it "should have the start_time of this hour" do 
       c = DateTime.current
       this_hour = DateTime.new(c.year,c.month,c.day, c.hour)         
       appointment = @user.create_appointment_now
       appointment.start_time.should eq(this_hour)
    end  
    it "should have the end_time of this hour" do 
       c = DateTime.current
       next_hour = DateTime.new(c.year,c.month,c.day, c.hour+1)         
       appointment = @user.create_appointment_now
       appointment.end_time.should eq(next_hour)
    end       
  end
  
  context "is_friend?" do
    it "should return true if is friend" do
      new_user = FactoryGirl.create(:user)
      Friendship.create_reciproke_friendship(@user,new_user)
      @user.is_friend?(new_user).should eq(true)
      new_user.is_friend?(@user).should eq(true)
    end
    it "should return false if is not friend" do
      new_user = FactoryGirl.create(:user)
      @user.is_friend?(new_user).should eq(false)
      new_user.is_friend?(@user).should eq(false)
    end
  end    
  
   context "class method current_users" do
     before(:each) do 
       @user_a = FactoryGirl.create(:user)
       @user_b = FactoryGirl.create(:user)
       @user_c = FactoryGirl.create(:user)
       FactoryGirl.create(:appointment, :user=>@user_a)
       FactoryGirl.create(:appointment, :user=>@user_b)
       FactoryGirl.create(:appointment, :user=>@user_c)
     end    
     
     it "should show no current_users, when nobody has logged in" do
       current_users = User.current_users
       current_users.should be_blank
     end
     
     it "should show 2 current_users, when 2 users have logged in" do
       DateTime.stub(:current).and_return(@user_a.appointments.first.start_time+5.minutes )
       @user_a.user_hours.first.store_login
       @user_b.user_hours.first.store_login
       current_users = User.current_users
       current_users.count.should eq(2)
       current_users.include?(@user_a).should eq(true)
       current_users.include?(@user_b).should eq(true)
     end    
     
     it "should not show current_users, when the following hours has started and nobody logged in" do
       DateTime.stub(:current).and_return(@user_a.appointments.first.start_time+5.minutes )
       @user_a.user_hours.first.store_login
       @user_b.user_hours.first.store_login
       DateTime.stub(:current).and_return(@user_a.appointments.first.start_time+65.minutes )       
       current_users = User.current_users
       current_users.should be_blank      
       end     
   end
   

  context "it finds an user for facebook authentication" do
    before(:each) do
       @access_token = mock("access_token",
         :extra =>
           mock("extra",
             :raw_info => mock("raw_info",
                :id => "4711",
                :email => "robert@startwork.in",
                :first_name => "Robert",
                :last_name => "Sarrazin")))
                
       User.any_instance.stub(:update_fb_friends)
     end    
     
     it "should create an user based on the access_token hash" do
       user = nil
       expect {
          user = User.find_for_facebook_oauth(@access_token)
       }.to change(User,:count).by(1) 
       user.first_name.should eq("Robert")
       user.last_name.should eq("Sarrazin")
       user.email.should eq("robert@startwork.in")
       user.fb_ui.should eq("4711")
     end
     
     it "should find an existing user" do
       existing_user = FactoryGirl.create(:user, :fb_ui => "4711")
       user = nil
       expect {
         user = User.find_for_facebook_oauth(@access_token)
       }.to change(User,:count).by(0) 
       user.should eq(existing_user)
     end
     
     it "should update the email and name of an existing user" do
       existing_user = FactoryGirl.create(:user, :fb_ui => "4711", :first_name=>"xxx", :email=>"xxx@xxx.com")
       user = nil
       expect {
         user = User.find_for_facebook_oauth(@access_token)
       }.to change(User,:count).by(0) 
       user.should eq(existing_user) 
       user.first_name.should eq("Robert")
       user.last_name.should eq("Sarrazin")
       user.email.should eq("robert@startwork.in")       
     end
     
     it "should call to update/create all FB friends" do
       User.any_instance.should_receive(:update_fb_friends).with(@access_token).exactly(1).times
       user = User.find_for_facebook_oauth(@access_token)
     end
     
  end
  
  context "it finds an usr for facebook requests" do  
    it "should find an existing user based on the fb_ui" do
      user = FactoryGirl.create(:user)
      found_user = User.find_for_facebook_request(user.fb_ui)
      found_user.should eq(user)      
    end
    
    it "should create an user when not existing based on the fb_ui" do
      fb_graph_user = mock "FbGraphUser"
      FbGraph::User.stub(:fetch).with("4711").and_return(fb_graph_user)
      fb_graph_user.should_receive(:first_name).and_return("Benedikt")
      fb_graph_user.should_receive(:last_name).and_return("Voigt")
      found_user = User.find_for_facebook_request("4711")
      found_user.first_name.should eq("Benedikt")     
      found_user.last_name.should eq("Voigt")
      found_user.fb_ui.should eq("4711")
      found_user.should be_valid
    end
  end
  
   context "updates FB friends" do
      before(:each) do
       @access_token = mock("access_token",
         :credentials =>
           mock("credentials",
             :token => "token"))
       @fb_robert = mock("FbGraph::User", :name => "Robert Sarrazin", :identifier => "Robert")
       @fb_miro = mock("FbGraph::User", :name => "Miro Wilms", :identifier => "Miro")
       FbGraph::User.stub_chain(:new, :fetch, :friends).and_return([@fb_robert,@fb_miro])   
#       User.any_instance.stub(:create_fb_friend)
       Friendship.stub(:create_reciproke_friendship)
      end
      
      it "should fetch the facebook user with the token" do
         @access_token.credentials.should_receive(:token).exactly(1).times
         FbGraph::User.should_receive(:new).exactly(1).times
         @user.update_fb_friends(@access_token)
      end        
      
      it "should create a reciproke friendship with a stored friend" do
        User.stub(:find_by_fb_ui).and_return(mock("friend", :id=>"xxx"))
        Friendship.should_receive(:create_reciproke_friendship).exactly(2).times
        @user.update_fb_friends(@access_token)
      end      

   end
   

   

end
