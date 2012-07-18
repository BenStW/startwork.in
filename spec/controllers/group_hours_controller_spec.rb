require 'spec_helper'

describe GroupHoursController do
 # render_views
 
  context "show - no own appointment, no other appointments" do
    before(:each) do
      @user = FactoryGirl.create(:user)
       sign_in @user      
    end
    
    it "should render success" do
      get :show
      response.should be_success
    end
    
    it "should create a new appointment" do
      expect{
        get :show
      }.to change(Appointment,:count).by(1)            
    end
    
    it "should create a user_hour of current hour" do
      expect{
        get :show
      }.to change(UserHour,:count).by(1)
      user_hour = @user.user_hours.current
      
      c = DateTime.current
      this_hour = DateTime.new(c.year,c.month,c.day, c.hour)
      user_hour.start_time.should eq(this_hour)      
    end
    
    it "should store the login in the user_hour" do
        get :show
        user_hour = @user.user_hours.current
        user_hour.login_count.should eq(1)
    end
    
    it "should assign the 3 tokbox variables" do
      get :show
      user_hour = @user.user_hours.current
      assigns(:tokbox_session_id).should eq(user_hour.group_hour.tokbox_session_id) 
      assigns(:tokbox_token).should_not be_nil        
      assigns(:tokbox_api_key).should_not be_nil        
    end
  end
  
  context "show - own appointment, no other appointments" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @appointment = FactoryGirl.create(:appointment, :user=>@user)
      DateTime.stub(:current).and_return(@appointment.start_time+5.minutes)     
      sign_in @user      
    end
    
    it "should render success" do
      get :show
      response.should be_success
    end  
    
    it "should not create a new appointment" do
      expect{
        get :show
      }.to change(Appointment,:count).by(0)     
    end
    
    it "should store the login in the user_hour" do
      user_hour = @user.user_hours.current
      expect {      
        get :show
        user_hour.reload
      }.to change(user_hour,:login_count).by(1)
    end   
    
    it "should not change the group_hour" do
      group_hour = @user.user_hours.current.group_hour
      get :show
      new_group_hour = @user.user_hours.current.group_hour
      new_group_hour.should eq(group_hour)
    end
     
    it "should assign the 3 tokbox variables" do
      get :show
      user_hour = @user.user_hours.current
      assigns(:tokbox_session_id).should eq(user_hour.group_hour.tokbox_session_id) 
      assigns(:tokbox_token).should_not be_nil        
      assigns(:tokbox_api_key).should_not be_nil        
    end    
  end
  
  context "show - own appointment, one other foreign appointment (not logged-in)" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @appointment = FactoryGirl.create(:appointment, :user=>@user)
      @foreign_user = FactoryGirl.create(:user)
      @foreign_appointment = FactoryGirl.create(:appointment, :user=>@foreign_user)
      DateTime.stub(:current).and_return(@appointment.start_time+5.minutes)     
#      @foreign_user.user_hours.current.store_login
      sign_in @user      
    end  
    
    it "should be success" do
      get :show
      response.should be_success            
    end
    
    it "should keep the two group_hours" do
      c = DateTime.current
      this_hour = DateTime.new(c.year,c.month,c.day, c.hour)      
      GroupHour.filter_on_start_time(this_hour).count.should eq(2)
      expect {
        get :show
      }.to change(GroupHour.filter_on_start_time(this_hour),:count).by(0)
    end
  end
  
    context "show - own appointment, one other foreign appointment (logged-in)" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        @appointment = FactoryGirl.create(:appointment, :user=>@user)
        @foreign_user = FactoryGirl.create(:user)
        @foreign_appointment = FactoryGirl.create(:appointment, :user=>@foreign_user)
        DateTime.stub(:current).and_return(@appointment.start_time+5.minutes)     
        @foreign_user.user_hours.current.store_login
        sign_in @user      
      end  

      it "should be success" do
        get :show
        response.should be_success            
      end

      it "should keep only one group_hour" do
        c = DateTime.current
        this_hour = DateTime.new(c.year,c.month,c.day, c.hour)      
        GroupHour.filter_on_start_time(this_hour).count.should eq(2)
        foreign_group_hour = @foreign_user.user_hours.current.group_hour
        expect {
          get :show
        }.to change(GroupHour.filter_on_start_time(this_hour),:count).by(-1)
        @user.user_hours.current.group_hour.should eq(foreign_group_hour)
      end
    end
    

  context "show - 2 couples" do
    before(:each) do
      
      @user_a = FactoryGirl.create(:user)
      @user_b = FactoryGirl.create(:user)      
      @appointment_a = FactoryGirl.create(:appointment, :user=>@user_a)
      @appointment_a.receive_and_accept(@user_b)

      @user_c = FactoryGirl.create(:user)
      @user_d = FactoryGirl.create(:user)      
      @appointment_c = FactoryGirl.create(:appointment, :user=>@user_c)
      @appointment_c.receive_and_accept(@user_d)
      
      sign_in @user_a   
      @user_b.user_hours.first.store_login
      @user_c.user_hours.first.store_login
      @user_d.user_hours.first.store_login    

      DateTime.stub(:current).and_return(@appointment_a.start_time+5.minutes)     
        
    end
    
    it "should keep the 2 separate group_hours" do
      c = DateTime.current
      this_hour = DateTime.new(c.year,c.month,c.day, c.hour)  
      GroupHour.filter_on_start_time(this_hour).count.should eq(2)
      expect {
        get :show
      }.to change(GroupHour.filter_on_start_time(this_hour),:count).by(0)            
    end
    
    it "should have the same tokbox_session_id as user_b" do
      get :show           
      assigns(:tokbox_session_id).should eq( @user_b.user_hours.current.group_hour.tokbox_session_id)       
    end
  end
    
    
  context "show - group of 3, group of 2, one single" do
     before(:each) do

       @user_a = FactoryGirl.create(:user)
       @user_b = FactoryGirl.create(:user)      
       @user_c = FactoryGirl.create(:user)      
       @appointment_a = FactoryGirl.create(:appointment, :user=>@user_a)
       @appointment_a.receive_and_accept(@user_b)
       @appointment_a.receive_and_accept(@user_c)

       @user_d = FactoryGirl.create(:user)
       @user_e = FactoryGirl.create(:user)      
       @appointment_d = FactoryGirl.create(:appointment, :user=>@user_d)
       @appointment_d.receive_and_accept(@user_e)

       @user_f = FactoryGirl.create(:user)
       sign_in @user_f   
       @user_a.user_hours.first.store_login
       @user_b.user_hours.first.store_login
       @user_c.user_hours.first.store_login    
       @user_d.user_hours.first.store_login
       @user_e.user_hours.first.store_login    

       DateTime.stub(:current).and_return(@appointment_a.start_time+5.minutes)     
     end

     it "should keep the 2 separate group_hours" do
       c = DateTime.current
       this_hour = DateTime.new(c.year,c.month,c.day, c.hour)  
       GroupHour.filter_on_start_time(this_hour).count.should eq(2)
       expect {
         get :show
       }.to change(GroupHour.filter_on_start_time(this_hour),:count).by(0)            
     end

     it "should get the same group_hour as the group of 2" do
       get :show           
       @user_f.user_hours.current.group_hour.should eq(@user_d.user_hours.current.group_hour)
     end
   end    
   
   context "show - group of 5, one single" do
      before(:each) do

        @user_a = FactoryGirl.create(:user)
        @user_b = FactoryGirl.create(:user)      
        @user_c = FactoryGirl.create(:user)      
        @user_d = FactoryGirl.create(:user)      
        @user_e = FactoryGirl.create(:user)      
        @appointment_a = FactoryGirl.create(:appointment, :user=>@user_a)
        @appointment_a.receive_and_accept(@user_b)
        @appointment_a.receive_and_accept(@user_c)
        @appointment_a.receive_and_accept(@user_d)
        @appointment_a.receive_and_accept(@user_e)

        @user_f = FactoryGirl.create(:user)
        sign_in @user_f   
        @user_a.user_hours.first.store_login
        @user_b.user_hours.first.store_login
        @user_c.user_hours.first.store_login    
        @user_d.user_hours.first.store_login
        @user_e.user_hours.first.store_login    

        DateTime.stub(:current).and_return(@appointment_a.start_time+5.minutes)     
      end

      it "should create a new group_hour" do
        c = DateTime.current
        this_hour = DateTime.new(c.year,c.month,c.day, c.hour)  
        GroupHour.filter_on_start_time(this_hour).count.should eq(1)
        expect {
          get :show
        }.to change(GroupHour.filter_on_start_time(this_hour),:count).by(1)            
      end

      it "should create a new group_hour only for the single user" do
        get :show           
        @user_f.user_hours.current.group_hour.users.count.should eq(1)
      end
    end   
  
  
  context "get_time" do
    before(:each) do 
      @user = FactoryGirl.create(:user)
      sign_in @user      
      @tomorrow_10am = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,10)+1.day
      DateTime.stub(:current).and_return(@tomorrow_10am)               
    end   
    
    it "should render the server time" do      
     get :get_time
     response.body.should eq(@tomorrow_10am.to_json)
     response.should be_success 
    end  
  end

end
