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
#

require 'spec_helper'

describe User do
  
  before(:each) do 
  #  Room.any_instance.stub(:populate_tokbox_session).and_return("tokbox_session_id")    
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

  #  it "should not be valid when last name is blank" do
  #    @user.last_name = " "
  #    @user.should_not be_valid
  #  end   
    
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
 #  
 #  it "should not be valid without a room" do
 #    @user.room = nil
 #    @user.should_not be_valid
 #  end
 #  
    it "should concatenate first and last name by method name" do
       name = "#{@user.first_name} #{@user.last_name}"
       @user.name.should eq(name)
    end
    
    
    it "should create a room after creation of the user" do
      new_user = User.create!(:first_name => "Ben", :email=>"ben@startwork.in", :fb_ui => "4711", :password=>"password")
      new_user.room.should_not be_nil
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
  
  context "registered_friends" do
    it "should return empty array if no friends" do
      registered_friends = @user.registered_friends
      registered_friends.should be_empty
    end
    it "should return empty array if friend is not registered" do
      new_user = FactoryGirl.create(:user, :registered=>false)
      Friendship.create_reciproke_friendship(@user,new_user)
      registered_friends = @user.registered_friends
      registered_friends.should be_empty            
    end
    it "should return array with friend if friend is registered" do
      new_user = FactoryGirl.create(:user)
      Friendship.create_reciproke_friendship(@user,new_user)
      new_user.registered.should eq(true)
      registered_friends = @user.registered_friends
     # registered_friends.should eq([new_user])       
    end     
    it "should return id, name and fb_ui if friend is registered" do
      new_user = FactoryGirl.create(:user)
      Friendship.create_reciproke_friendship(@user,new_user)
      registered_friend = @user.registered_friends[0]    
      registered_friend.id.should eq(new_user.id)      
      registered_friend.first_name.should eq(new_user.first_name)      
      registered_friend.fb_ui.should eq(new_user.fb_ui)         
      registered_friend.registered.should eq(new_user.registered)         
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
       user.room.should_not eq(nil)
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
     
     it "should populate the tokbox_session_id in its room" do
       TokboxApi.stub_chain(:instance, :generate_session).and_return("tokbox_session_id")  
       user = User.find_for_facebook_oauth(@access_token)
       user.room.tokbox_session_id.should eq("tokbox_session_id")        
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
       User.any_instance.stub(:create_fb_friend)
       Friendship.stub(:create_reciproke_friendship)
       WorkSession.stub(:optimize_single_work_sessions)
      end
      
      it "should fetch the facebook user with the token" do
         @access_token.credentials.should_receive(:token).exactly(1).times
         FbGraph::User.should_receive(:new).exactly(1).times
         @user.update_fb_friends(@access_token)
      end  
      
      it "should call create_fb_friend for each not stored friend" do
        User.stub(:find_by_fb_ui).and_return(nil)
        User.any_instance.should_receive(:create_fb_friend).with(@fb_robert).exactly(1).times
        User.any_instance.should_receive(:create_fb_friend).with(@fb_miro).exactly(1).times
        @user.update_fb_friends(@access_token)
      end
      
      it "should not call create_fb_friend for each stored friend" do
        User.stub(:find_by_fb_ui).and_return(mock("FB Friend", :id=>"xxx"))
        User.any_instance.should_not_receive(:create_fb_friend)
        @user.update_fb_friends(@access_token)
      end  
      
      it "should create a reciproke friendship with a not stored friend" do
        User.stub(:find_by_fb_ui).and_return(nil)
        User.any_instance.stub(:create_fb_friend).and_return(mock("friend")) #, :id=>"xxx"))
        Friendship.should_receive(:create_reciproke_friendship).exactly(2).times
        @user.update_fb_friends(@access_token)
      end 
      
      it "should create a reciproke friendship with a stored friend" do
        User.stub(:find_by_fb_ui).and_return(mock("friend", :id=>"xxx"))
        Friendship.should_receive(:create_reciproke_friendship).exactly(2).times
        @user.update_fb_friends(@access_token)
      end      
      
    # it "should call to optimize the single worksessions" do
    #   WorkSession.should_receive(:optimize_single_work_sessions).exactly(1).times
    #   @user.update_fb_friends(@access_token)
    # end
   end
   
   context "create FB friend" do
     before(:each) do
       @fb_robert = mock("FbGraph::User", :name => "Robert Sarrazin", :identifier => "Robert")
     end
     
     it "creates a FB friend" do
       expect {
         user = @user.create_fb_friend(@fb_robert)
       }.to change(User,:count).by(1)       
     end
     
     it "stores the name of the FB friend" do
       user = @user.create_fb_friend(@fb_robert)
       user.first_name.should eq("Robert Sarrazin")
     end

     it "stores the fb id of the FB friend" do
       user = @user.create_fb_friend(@fb_robert)
       user.fb_ui.should eq("Robert")
     end     
    # it "creates "
     
     
     
   end
     
     
  #   it "should create an user based on the friend hash" do
  #     user = nil
  #     expect {
  #        user = User.find_or_create_fb_friend(@fb_robert)
  #     }.to change(User,:count).by(1) 
  #     user.first_name.should eq("Robert Sarrazin")
  #     user.email.should eq("tmp@startwork.in")
  #     user.fb_ui.should eq("4711")
  #     user.room.should_not eq(nil)
  #   end
  #   
  #   it "should find an existing user by the facebook UI" do
  #     existing_user = FactoryGirl.create(:user, :fb_ui => "4711")
  #     user = nil
  #     expect {
  #        user = User.find_or_create_fb_friend(@fb_robert)
  #     }.to change(User,:count).by(0) 
  #     user.should eq(existing_user)          
  #   end 
  # end
  #
 # context "it finds or creates a user based on facebook ID" do
 #   before do
 #     # @existing_user = FactoryGirl.create(:user)
 #    #  @fb_robert = mock("FbGraph::User", :first_name => "Robert", :last_name =>"Sarrazin", :identifier => "4711")
 #      
 #      @access_token = mock("access_token",
 #        :extra =>
 #          mock("raw_info",
 #            :email => "robert@startwork.in",
 #            :first_name = "Robert",
 #            :last_name = "Sarrazin"))
 #     Room.any_instance.stub(:populate_tokbox_session).and_return("tokbox_session_id")             
 #    end
 #      
 #   it "should return an existing user by fb ID" do   
 #     user = User.find_or_create(@existing_user.fb_ui)
 #     user.should eq(@existing_user)
 #   end
 #   
 #   it "should return an user when not existing" do
 #     user = User.find_or_create(@fb_robert.identifier)
 #     user.class.should eq(User)      
 #   end
 #   
 #   it "should create an user with first_name and last_name received by FB" do
 #     user = User.find_or_create(@fb_robert.identifier)
 #     user.first_name = @fb_robert.first_name    
 #     user.last_name = @fb_robert.last_name    
 #   end
 # end
end
