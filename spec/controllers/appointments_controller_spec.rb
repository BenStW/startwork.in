require 'spec_helper'
#require 'ruby-debug19'

describe AppointmentsController do
  
   context "get_token" do
     before(:each) do
       @user = FactoryGirl.create(:user)
       sign_in @user
     end
     
     it "should be success" do      
       get :get_token
       response.should be_success 
     end
     
     it "should create an appointment" do
       tomorrow_at_9am = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,9)+1.day
       tomorrow_at_11am = tomorrow_at_9am + 2.hours
       expect {
         get :get_token, :start_time=>tomorrow_at_9am, :end_time=>tomorrow_at_11am
      }.to change(Appointment, :count).by(1)
     end
     
     it "should return the token of the appointment" do
        tomorrow_at_9am = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,9)+1.day
        tomorrow_at_11am = tomorrow_at_9am + 2.hours
        response = get :get_token, :start_time=>tomorrow_at_9am, :end_time=>tomorrow_at_11am
        response.body.should eq(Appointment.first.token)
     end
   end
   
   context "show" do
     before(:each) do
       @user = FactoryGirl.create(:user)
     end
     
     it "should be success without signing in " do      
       get :show
       response.should be_success 
     end 
     it "should respond 'keine Verabredung gefunden' if no appointment" do             
       response = get :show
       response.body.should eq("keine Verabredung gefunden")
     end  
     it "should render template 'show'" do     
       appointment = FactoryGirl.create(:appointment, :sender=>@user)       
       response = get :show, :token=>appointment.token
       response.should render_template("show")
     end  
     it "should assign the appointment" do     
       appointment = FactoryGirl.create(:appointment, :sender=>@user)       
       response = get :show, :token=>appointment.token
       assigns(:appointment).should eq(appointment)        
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