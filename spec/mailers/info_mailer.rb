require "spec_helper"

describe InfoMailer do
  
  context "general" do

    before(:each) do
      ActionMailer::Base.deliveries = []
    end

    it 'should send an email for a new user' do
      user = FactoryGirl.create(:user)
      InfoMailer.deliver_new_user(user).deliver
      
      mail = ActionMailer::Base.deliveries.first
      mail.subject.should =~ /Neuer Nutzer: #{user.name}/ 
    end
    
 end

end
