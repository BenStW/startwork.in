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
       get :show, :id =>@appointment.id, :token=>@appointment.token
       response.should be_success 
     end 
 
     it "should render template 'show'" do     
       get :show, :id =>@appointment.id, :token=>@appointment.token
       response.should render_template("show")
     end   
     
     it "should render template 'errors/404' when no appointment token" do     
       get :show, :id =>@appointment.id
       response.should render_template("errors/404")
     end  

     it "should assign the appointment" do     
       get :show, :id =>@appointment.id, :token=>@appointment.token
       assigns(:appointment).should eq(@appointment)        
     end   
     
     it "should add appointment to received_appointments when user is logged in" do
         recipient_user = FactoryGirl.create(:user)
         sign_in recipient_user         
         puts "RecipientAppointment.count = #{RecipientAppointment.count}"
        expect {
           get :show, :id =>@appointment.id, :token=>@appointment.token
         }.to change(RecipientAppointment, :count).by(1)
     end
     
     it "should not add appointment to received_appointments twice" do
         recipient_user = FactoryGirl.create(:user)
         sign_in recipient_user         
         puts "RecipientAppointment.count = #{RecipientAppointment.count}"
        expect {
           get :show, :id =>@appointment.id, :token=>@appointment.token
           get :show, :id =>@appointment.id, :token=>@appointment.token
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
              :token => Appointment.last.token
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
    end
    
    it "should be success" do      
      put :update, :appointment=>@data
      response.should be_success 
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
    def accept_without_authentication
      session[:appointment_token] = params["token"]
      redirect_to appointment_accept_url
    end
    
    context "accept_without_authentication" do
      before(:each) do
        @user = FactoryGirl.create(:user)
      end
       it "should redirect to root_url without signing in" do      
         get :accept_without_authentication
         response.should redirect_to(appointment_accept_url)
       end
     end
     
     context "accept" do
       before(:each) do
         @user = FactoryGirl.create(:user)
         sign_in @user
         @appointment = FactoryGirl.create(:appointment, :sender=>@user)
         session[:appointment_token] = @appointment.token
       end
       it "should respond 'keine Verabredung gefunden' if no appointment" do  
         session[:appointment_token] = "asdf"           
         response = get :accept
         response.body.should eq("keine Verabredung gefunden")
       end
       it "should increment receive_count of appointment by 1" do
         Appointment.first.receive_count.should eq(0)
         get :accept
         Appointment.first.receive_count.should eq(1)
       end
       it "should create 2 calendar events for an appointment of 2 hours" do
         expect{
          get :accept
        }.to change(CalendarEvent,:count).by(2)
       end  
       it "should redirect to calendar_url " do      
         get :accept
         response.should redirect_to(calendar_url)
       end            
    end     
   
 end