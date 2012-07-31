require 'spec_helper'

describe RequestsController do
  render_views
  context "create" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      sign_in @user
      @appointment = FactoryGirl.create(:appointment,:user=>@user)
    end
    
    it "should be success" do   
      get :create, :request_str=>"asdf", :appointment_id=>@appointment.id
      response.should be_success 
    end

    it "should create a request object" do   
      expect {
      get :create, :request_str=>"asdf", :appointment_id=>@appointment.id
    }.to change(Request,:count).by(1)
    end
   
     
  end
end
