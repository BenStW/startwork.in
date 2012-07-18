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
      get :show
      user_hour = UserHour.all.first
      
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
