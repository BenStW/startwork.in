require 'spec_helper'

describe TokboxApi do
  
  context "methods" do
    
    before(:each) do
   #   TokboxApi.unstub(:instance)
    end
    
    
    it "is a singleton object" do
      TokboxApi.instance.should eq(TokboxApi.instance)
    end
    
    it "generates a session without IP-address" do
      tokbox_session = TokboxApi.instance.generate_session      
      #session = TokboxApi.instance.generate_session
      tokbox_session.should_not eq(nil)
    end
    
    it "generates a session with IP-address" do
      session = TokboxApi.instance.generate_session("0.0.0.0")
      session.should_not eq(nil)
    end    
    
    it "generates a token when session and user are given" do
      session = TokboxApi.instance.generate_session
      user = mock("User", :name=>"Ben", :id=>4711)
    #  user = FactoryGirl.create(:user)
      token = TokboxApi.instance.generate_token(session, user)
      token.should_not eq(nil)
    end  
    
    it "does not generate a token without user" do
      session = TokboxApi.instance.generate_session("0.0.0.0")
      user = FactoryGirl.create(:user)
      lambda{TokboxApi.instance.generate_token(session)}.should raise_error          
    end  

  end
  
  
end
