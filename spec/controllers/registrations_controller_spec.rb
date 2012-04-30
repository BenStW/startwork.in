require 'spec_helper'

describe RegistrationsController do
  render_views
  

  it "stores the referer in the user model" do
    TokboxApi.any_instance.stub(:generate_session => "stubbed tokbox_session_id")
    request.env["devise.mapping"] = Devise.mappings[:user]
    session[:referer] = "Facebook"
    post :create, :user => {:first_name => "Ben",:last_name => "foo", :email => "ben@example.com", :password => "secret", :password_confirmation=>"secret"}
    u = User.find_by_first_name("Ben")
    u.referer.should == "Facebook"
  end 
  
  it "creates a work session room for the user" do
    TokboxApi.any_instance.stub(:generate_session => "stubbed tokbox_session_id")
    request.env["devise.mapping"] = Devise.mappings[:user]
    post :create, :user => {:first_name => "Ben",:last_name => "foo",  :email => "ben@example.com", :password => "secret", :password_confirmation=>"secret"}
    u = User.find_by_first_name("Ben")
    u.room.tokbox_session_id.should_not be_nil
    puts "tokbox_session_id=#{u.room.tokbox_session_id}"
  end    

end
