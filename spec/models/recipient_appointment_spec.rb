# == Schema Information
#
# Table name: recipient_appointments
#
#  id             :integer         not null, primary key
#  user_id        :integer
#  appointment_id :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

require 'spec_helper'

describe RecipientAppointment do
 context "when created" do
    before(:each) do 
      @recipient_appointment = FactoryGirl.create(:recipient_appointment)  
    end    
    
    it "should be valid with attributes from factory" do
      @recipient_appointment.should be_valid
    end
    
    it "should not be valid without an user" do
      @recipient_appointment.user = nil
      @recipient_appointment.should_not be_valid
    end 
    
    it "should not be valid without an appointment" do
      @recipient_appointment.appointment_id  = nil
      @recipient_appointment.should_not be_valid
    end   
    
    it "should not be valid with own appointment" do
      user = FactoryGirl.create(:user)
      appointment = FactoryGirl.create(:appointment, :user=>user)
      recipient_appointment = RecipientAppointment.create(:user=>user, :appointment=>appointment)
      recipient_appointment.should_not be_valid
    end    
  end
  
  context "associations " do
     before(:each) do 
       @user_a = FactoryGirl.create(:user)
       @user_b = FactoryGirl.create(:user)
       @appointment_a = FactoryGirl.create(:appointment, :user=>@user_a)
       @recipient_appointment = @user_b.recipient_appointments.create(:user=>@user_b, :appointment=>@appointment_a)
     end  
     
     it "should belong to the original appointment" do
        @recipient_appointment.appointment.should eq(@appointment_a)
     end
     
     it "should make the original sender accessible" do
        @recipient_appointment.sender.should eq(@user_a)
      end
      
      it "should be deleted when the original appointment is deleted" do
        expect { @appointment_a.destroy }.to change(RecipientAppointment, :count).by(-1)
      end
    end
   
   context "group_hour" do
     before(:each) do 
       @user_a = FactoryGirl.create(:user)
       @user_b = FactoryGirl.create(:user)
       @appointment_a = FactoryGirl.create(:appointment, :user=>@user_a)
       @recipient_appointment = @user_b.recipient_appointments.create(:user=>@user_b, :appointment=>@appointment_a)
     end
     
     it "should return the group_hour of the original appointment" do
       start_time = @appointment_a.start_time
       group_hour = @recipient_appointment.group_hour(start_time)
       @user_a.user_hours.find_by_start_time(start_time).group_hour.should eq(group_hour)
     end
     
     it "should raise an error when no group_hour of the original appointment" do
       start_time = @appointment_a.start_time-1.hour
       lambda {
       group_hour = @recipient_appointment.group_hour(start_time)
       }.should raise_error
     end     
   end
  
end
