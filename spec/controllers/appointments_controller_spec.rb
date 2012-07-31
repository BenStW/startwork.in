require 'spec_helper'
#require 'ruby-debug19'

describe AppointmentsController do
  render_views
  
  
  context "index" do
    before(:each) do
      @my_user = FactoryGirl.create(:user)
      sign_in @my_user
      @my_appointment_a = FactoryGirl.create(:appointment,:user=>@my_user)
      @my_appointment_b = FactoryGirl.create(:appointment,:user=>@my_user,:start_time=>@my_appointment_a.start_time+1.day,:end_time=>@my_appointment_a.end_time+1.day)
      @foreign_user = FactoryGirl.create(:user)
      @foreign_appointment_c = FactoryGirl.create(:appointment,:user=>@foreign_user)
    end
    
    it "should be success" do   
      get :index
      response.should be_success 
    end
    
    it "should render partial template _appointments 1 time" do
       get :index 
       response.should render_template(:partial => "_appointments", :count => 1)
    end     
    
    it "should render partial template _appointment 2 times" do
       get :index 
       response.should render_template(:partial => "_appointment", :count => 2)
    end     
    
    it "shows my appointments of this week" do
       get :index
       assigns(:my_appointments).should eq([@my_appointment_a,@my_appointment_b])          
    end  
  end


  
   context "show" do
     before(:each) do
       @user = FactoryGirl.create(:user)       
       @appointment = FactoryGirl.create(:appointment, :user=>@user)
     end
     
     it "should be success without signing in" do      
       get :show, :id =>@appointment.id, :id=>@appointment.id
       response.should be_success 
     end 
 
     it "should render template 'show'" do     
       get :show, :id =>@appointment.id, :id=>@appointment.id
       response.should render_template("show")
     end   
     
     it "should raise en error when no appointment id" do 
       expect {    
         get :show
       }.to raise_error
     end  

     it "should assign the appointment" do     
       get :show, :id =>@appointment.id, :id=>@appointment.id
       assigns(:appointment).should eq(@appointment)        
     end   
     
     it "should add appointment to received_appointments when user is logged in" do
         recipient_user = FactoryGirl.create(:user)
         sign_in recipient_user         
         puts "RecipientAppointment.count = #{RecipientAppointment.count}"
        expect {
           get :show, :id =>@appointment.id, :id=>@appointment.id
         }.to change(RecipientAppointment, :count).by(1)
         recipient_user.received_appointments.should_not be_blank   
     end
     
     it "should not add appointment to received_appointments twice" do
         recipient_user = FactoryGirl.create(:user)
         sign_in recipient_user         
         puts "RecipientAppointment.count = #{RecipientAppointment.count}"
        expect {
           get :show, :id =>@appointment.id, :id=>@appointment.id
           get :show, :id =>@appointment.id, :id=>@appointment.id
         }.to change(RecipientAppointment, :count).by(1)      
     end     
  end  
  
  context "create" do
    before(:each) do
      @user = FactoryGirl.create(:user) 
      @start_time = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,10)+1.day
      @end_time = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,12)+1.day      
      @data = Hash.new
      @data[:start_time] = @start_time
      @data[:end_time] = @end_time
      sign_in @user      
    end
    
    it "should be success" do      
      post :create, :appointment=>@data
      response.should be_success 
    end  
    
    it "should create an appointment" do
      expect {
        post :create, :appointment=>@data
      }.to change(Appointment,:count).by(1)
    end      
      
    it "should create an appointment" do
     expect {
       post :create, :appointment=>@data
     }.to change(Appointment,:count).by(1)
    end   
    
    it "should return the appointment as JSON" do
      post :create, :appointment=>@data      
      @expected = { 
              :start_time  => @start_time ,
              :end_time     => @end_time,
              :id => Appointment.last.id,
              :id => Appointment.last.id
      }
      body = response.body
      obj = ActiveSupport::JSON.decode(body)   
      obj.count.should eq(@expected.count)
      obj.each do |key,value| 
        @expected[key.to_sym].should eq(value)
      end 
    end   
    
    it "should render a 404 error if no appointment was created" do
       FactoryGirl.create(:appointment, :user=>@user)
       post :create, :appointment=>@data      
       response.should render_template("errors/404")             
    end
  end
  
  
  context "update" do
    before(:each) do
      @user = FactoryGirl.create(:user) 
      @appointment = FactoryGirl.create(:appointment, :user=>@user)
      sign_in @user   
      @new_times = Hash.new
      @new_times[:start_time] = @appointment.start_time+1.hour 
      @new_times[:end_time] = @appointment.end_time+1.hour 
    end
    
    it "should be success" do      
      put :update, :id=>@appointment.id, :appointment=>@new_times
      response.should be_success 
    end
    it "should update the times of the appointment" do      
      put :update, :id=>@appointment.id, :appointment=>@new_times
      @appointment.reload
      @appointment.start_time.should eq(@new_times[:start_time])
      @appointment.end_time.should eq(@new_times[:end_time])
    end   
    it "should return a 422 status when appointment can't be updated" do
       new_appointment = FactoryGirl.create(:appointment, :user=>@user, :start_time=>@appointment.end_time, :end_time=>@appointment.end_time+3.hours)
       put :update, :id=>@appointment.id, :appointment=>@new_times
       response.should_not be_success
       response.response_code.should == 422        
    end
  end  
  
  context "destroy" do
    before(:each) do
      @user = FactoryGirl.create(:user) 
      @appointment = FactoryGirl.create(:appointment, :user=>@user)
      sign_in @user   
    end
    
    it "should be success" do      
      delete :destroy, :id=>@appointment.id
      response.should be_success 
    end  
    it "should delete the appointment" do
      expect {
        delete :destroy, :id=>@appointment.id      
      }.to change(Appointment,:count).by(-1)
    end
    it "should not be possible to delete a foreign appointment" do
      foreign_appointment = FactoryGirl.create(:appointment)
      expect {
        delete :destroy, :id=>foreign_appointment.id
      }.to raise_error
      foreign_appointment.reload
      foreign_appointment.should_not be_nil
    end
  end
  
  context "show_and_welcome" do
    before(:each) do
      sender = FactoryGirl.create(:user) 
      @appointment = FactoryGirl.create(:appointment, :user=>sender)
      @user = FactoryGirl.create(:user) 
      sign_in @user   
    end
    
    it "should be success" do      
      get :show_and_welcome, :id=>@appointment.id
      response.should be_success 
    end
    it "should raise an error when appointment is not found" do
      expect {
        get :show_and_welcome, :id=>"asdf"
      }.to raise_error
    end    
    
    it "should add appointment to received_appointments" do
       expect {
          get :show_and_welcome, :id=>@appointment.id
        }.to change(RecipientAppointment, :count).by(1)
      @user.received_appointments.should eq([@appointment])        
    end    
    
    it "should assign the friends" do
       friend = FactoryGirl.create(:user)
       Friendship.create_reciproke_friendship(@user,friend)
       get :show_and_welcome, :id=>@appointment.id       
       assigns(:friends).should eq([friend])
    end    
  end  
  
  
  context "reject" do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end
     it "should be redirect to root_url without signing in" do      
       get :reject
       response.should redirect_to(root_url)
     end
  end  
  
  
   context "accept" do
     before(:each) do
       sender = FactoryGirl.create(:user) 
       @appointment = FactoryGirl.create(:appointment, :user=>sender)
       @user = FactoryGirl.create(:user) 
       sign_in @user
     end
     it "should raise an error when appointment is not found" do
       expect {
         get :accept, :id=>"asdf"
       }.to raise_error
     end     
     it "should add the appointment to received_appointments" do      
       get :accept, :id=>@appointment.id
       @user.received_appointments.should eq([@appointment])
     end   

     it "should create a new appointment" do
       @user.appointments.should be_blank
       get :accept, :id=>@appointment.id
       @user.reload
       @user.appointments.should_not be_blank
     end  
     it "should redirect to root_url" do
       get :accept, :id=>@appointment.id
       response.should redirect_to(root_url)       
     end   
     it "should not redirect when requested as JSON" do
       get :accept, :id=>@appointment.id, :format => :json
       response.should_not redirect_to(root_url)       
     end     
     it "should return ok when requested as JSON" do
       get :accept, :id=>@appointment.id, :format => :json
       response.body.should eq("ok")
     end     

  end 
  

   context "accept_and_redirect_to_appointment_with_welcome" do
     before(:each) do
       sender = FactoryGirl.create(:user) 
       @appointment = FactoryGirl.create(:appointment, :user=>sender)
       @user = FactoryGirl.create(:user) 
       sign_in @user
     end
     it "should raise an error when appointment is not found" do
       expect {
         get :accept_and_redirect_to_appointment_with_welcome, :id=>"asdf"
       }.to raise_error
     end     
     it "should add the appointment to received_appointments" do      
       get :accept_and_redirect_to_appointment_with_welcome, :id=>@appointment.id
       @user.received_appointments.should eq([@appointment])
     end   

     it "should create a new appointment" do
       @user.appointments.should be_blank
       get :accept_and_redirect_to_appointment_with_welcome, :id=>@appointment.id
       @user.reload
       @user.appointments.should_not be_blank
     end  
     it "should redirect to root_url" do
       get :accept_and_redirect_to_appointment_with_welcome, :id=>@appointment.id
       response.should redirect_to(show_and_welcome_appointment_url(:id => @appointment.id))       
     end   
  end 
  
   context "receive" do
     before(:each) do
       @sender = FactoryGirl.create(:user) 
       @appointment = FactoryGirl.create(:appointment, :user=>@sender)
       sign_in @sender
     end
     it "should raise an error when appointment is not found" do
       expect {
         get :receive, :id=>"asdf"
       }.to raise_error
     end     
     it "should add the appointment as received_appointment for the registered user" do   
       registered_user = FactoryGirl.create(:user)   
       get :receive, :id=>@appointment.id, :user_ids=>["#{registered_user.fb_ui}"]
       registered_user.received_appointments.should eq([@appointment])
     end   
     it "should add the appointment as received_appointment for the non registered user" do      
       non_registered_user = mock "FbGraphUser"
       FbGraph::User.stub(:fetch).with("4711").and_return(non_registered_user)
       non_registered_user.should_receive(:first_name).and_return("Benedikt")
       non_registered_user.should_receive(:last_name).and_return("Voigt")       
       get :receive, :id=>@appointment.id, :user_ids=>["4711"]       
       user = User.find_by_fb_ui("4711")
       user.received_appointments.should eq([@appointment])
     end     
  end  
     
  
   
 end