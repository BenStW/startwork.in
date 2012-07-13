# == Schema Information
#
# Table name: appointments
#
#  id            :integer         not null, primary key
#  start_time    :datetime
#  end_time      :datetime
#  token         :string(255)
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#  send_count    :integer
#  receive_count :integer
#  user_id       :integer
#

require 'spec_helper'

describe Appointment do
 context "when created" do
    before(:each) do 
      @appointment = FactoryGirl.create(:appointment)  
    end    
    
    it "should be valid with attributes from factory" do
      @appointment.should be_valid
    end
    
    it "should not be valid without an user" do
      @appointment.user_id = nil
      expect {
        @appointment.valid?
      }.should raise_error
    end 
    
    it "should initialize send_count and receive_count" do
      @appointment.send_count.should eq(0)
      @appointment.receive_count.should eq(0)
    end   
    
    it "should generate a token" do
      @appointment.token.should_not be_nil
    end
    
    it "should not be valid without start_time" do
      @appointment.start_time = nil
      @appointment.should_not be_valid      
    end    
    
    it "should not be valid without end_time" do
      @appointment.end_time = nil
      @appointment.should_not be_valid      
    end   
    
    it "should not be valid when start_time equals end_time" do
      @appointment.end_time = @appointment.start_time
      @appointment.should_not be_valid      
    end   

    it "should not be valid when start_time is greater then end_time" do
      @appointment.end_time = @appointment.start_time - 1.hour
      @appointment.should_not be_valid      
    end   
    
    it "should not be valid when appointment has the same time" do
       user = @appointment.user
       start_time = @appointment.start_time
       end_time = @appointment.end_time
       new_appointment = FactoryGirl.build(:appointment, :user=>user, :start_time=>start_time, :end_time=>end_time)
       new_appointment.should_not be_valid
    end      
    
    it "should not be valid when appointment overlaps by one hour" do
       user = @appointment.user
       start_time = @appointment.start_time+1.hour
       end_time = @appointment.end_time+1.hour
       new_appointment = FactoryGirl.build(:appointment, :user=>user, :start_time=>start_time, :end_time=>end_time)
       new_appointment.should_not be_valid
    end 
    
    it "should be valid when appointment does not overlap by one hour" do
       user = @appointment.user
       start_time = @appointment.start_time+2.hour
       end_time = @appointment.end_time+2.hour
       new_appointment = FactoryGirl.create(:appointment, :user=>user, :start_time=>start_time, :end_time=>end_time)
       new_appointment.should be_valid
    end    
    
    it "destroys the user_hours when appointment is destroyed" do
      @appointment.destroy
      UserHour.count.should eq(0)
    end
  end
 
  context "associations" do    
    it "has two users when work_hour has two users" do
      user_a = FactoryGirl.create(:user)
      user_b = FactoryGirl.create(:user)
      user_c = FactoryGirl.create(:user)

      appointment_a = FactoryGirl.create(:appointment, :user=>user_a)
      FactoryGirl.create(:recipient_appointment, :user=>user_b, :appointment=>appointment_a)
      Appointment.accept_received_appointment(user_b,appointment_a)
      appointment_a.users.count.should eq(2)
      appointment_a.users.include?(user_a).should eq(true)
      appointment_a.users.include?(user_b).should eq(true)
      appointment_a.users.include?(user_c).should eq(false)
    end
  end

  
  context "class method split_to_hourly_start_times" do    
     before(:each) do 
       @start_time = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,10)+1.day
       @end_time = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,13)+1.day
     end  
     
     it "should split the 3 hour appointment into 3 hours" do
        start_times = Appointment.split_to_hourly_start_times(@start_time, @end_time)
        start_times.count.should eq(3)
        start_times[0].should eq(@start_time)
        start_times[1].should eq(@start_time+1.hour)
        start_times[2].should eq(@start_time+2.hour)
     end
     
     it "should raise an error when end_time before start_time" do
        lambda {
          start_times = Appointment.split_to_hourly_start_times(@end_time,@start_time)
        }.should raise_error  
     end    
     
     it "should raise an error when start_time has minutes" do
       @start_time+= 10.minutes
        lambda {
          start_times = Appointment.split_to_hourly_start_times(@start_time, @end_time)
        }.should raise_error  
     end    
     it "should raise an error when start_time and end_time has different days" do
       @end_time+= 1.day
        lambda {
          start_times = Appointment.split_to_hourly_start_times(@start_time, @end_time)
        }.should raise_error  
     end       
   end 
   
   context "generates user_hours for each hour" do    
      before(:each) do 
         @appointment = FactoryGirl.create(:appointment)  
      end  
      
      it "should create two user_hours for a 2 hour appointment" do
        @appointment.user_hours.count.should eq(2)        
      end 
      
      it "should keep the two user_hours when extending to 3 hour appointment" do
        @user_hours = @appointment.user_hours
        @appointment.end_time += 1.hour
        @appointment.save
        @appointment.user_hours.count.should eq(3)
        @user_hours.each do |user_hour|
          @appointment.user_hours.should include(user_hour)
        end
      end 
      
      it "should delete one user_hour when moving the end of the appointment by 1 hour" do
        @user_hours = @appointment.user_hours
        @appointment.end_time -= 1.hour
        @appointment.save
        @appointment.user_hours.count.should eq(1)        
      end
      
      it "should delete one user_hour when moving the start of the appointment by 1 hour" do
        @user_hours = @appointment.user_hours
        @appointment.start_time += 1.hour
        @appointment.save
        @appointment.user_hours.count.should eq(1)        
      end   

      it "should assign the user_hour of the accepted_appointment" do
         user_a = FactoryGirl.create(:user)
         appointment_a = FactoryGirl.create(:appointment, :user=>user_a)
         user_b = FactoryGirl.create(:user)
         recipient_appointment = RecipientAppointment.create(:user=>user_b, :appointment=>appointment_a)         
         appointments_b = Appointment.accept_received_appointment(user_b, appointment_a)
         appointment_b = appointments_b.first
         appointment_a.user_hours.first.group_hour.should eq(appointment_b.user_hours.first.group_hour) 
         appointment_a.user_hours.last.group_hour.should eq(appointment_b.user_hours.last.group_hour) 
      end      
           
   end 
   
   context "class method can_create_new_appointment" do    
      before(:each) do 
         @user = FactoryGirl.create(:user)
      end
      
      it "should render true when no appointment exists" do
        start_time = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,10)+1.day
        end_time = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,12)+1.day
        Appointment.can_create_new_appointment?(@user, start_time, end_time).should eq(true)
      end
      
      it "should render false when appointment at this time exists" do
        start_time = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,10)+1.day
        end_time = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,12)+1.day
        @appointment = FactoryGirl.create(:appointment, :user=>@user, :start_time=>start_time, :end_time=>end_time)
        Appointment.can_create_new_appointment?(@user, start_time, end_time).should eq(false)
      end   
      
      it "should render false when appointment overlaps" do
        start_time = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,10)+1.day
        end_time = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,12)+1.day
        @appointment = FactoryGirl.create(:appointment, :user=>@user, :start_time=>start_time, :end_time=>end_time)
        Appointment.can_create_new_appointment?(@user, start_time+1.hour, end_time+1.hour).should eq(false)
      end    
      
      it "should render true when appointment does not overlap" do
        start_time = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,10)+1.day
        end_time = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,12)+1.day
        @appointment = FactoryGirl.create(:appointment, :user=>@user, :start_time=>start_time, :end_time=>end_time)
        Appointment.can_create_new_appointment?(@user, start_time+2.hour, end_time+2.hour).should eq(true)
      end 
    end   
    
    context "class method get_possible_appointment_slots for 10-13" do
      before(:each) do 
         @user = FactoryGirl.create(:user)
         @start_time = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,10)+1.day
         @end_time = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,13)+1.day
      end   
      
      it "should return a 10-13 slot if no appointments" do
        slots = Appointment.get_possible_appointment_slots(@user,@start_time,@end_time)
        slots.count.should eq(1)
        slots.first[:start_time].should eq(@start_time)
        slots.first[:end_time].should eq(@end_time)
      end
      
      it "should return no slot if appointment from 10-13" do
        appointment = FactoryGirl.create(:appointment, :user=>@user, :start_time=>@start_time, :end_time=>@end_time)
        slots = Appointment.get_possible_appointment_slots(@user,@start_time,@end_time)
        slots.count.should eq(0)
      end    
      
      it "should return 10-11 if appointment from 11-14" do
        appointment = FactoryGirl.create(:appointment, :user=>@user, :start_time=>@start_time+1.hour, :end_time=>@end_time+1.hour)
        slots = Appointment.get_possible_appointment_slots(@user,@start_time,@end_time)
        slots.count.should eq(1)
        slots.first[:start_time].should eq(@start_time)
        slots.first[:end_time].should eq(@start_time+1.hour)        
      end    
      it "should return 12-13 if appointment from 9-12" do
        appointment = FactoryGirl.create(:appointment, :user=>@user, :start_time=>@start_time-1.hour, :end_time=>@end_time-1.hour)
        slots = Appointment.get_possible_appointment_slots(@user,@start_time,@end_time)
        slots.count.should eq(1)
        slots.first[:start_time].should eq(@end_time-1.hour)
        slots.first[:end_time].should eq(@end_time)        
      end  
      it "should return 10-11 and 12-13 if appointment from 11-12" do
        appointment = FactoryGirl.create(:appointment, :user=>@user, :start_time=>@start_time+1.hour, :end_time=>@end_time-1.hour)
        slots = Appointment.get_possible_appointment_slots(@user,@start_time,@end_time)
        slots.count.should eq(2)
        slots.first[:start_time].should eq(@start_time)
        slots.first[:end_time].should eq(@start_time+1.hour)        
        slots.last[:start_time].should eq(@end_time-1.hour)
        slots.last[:end_time].should eq(@end_time)        
      end          
      
    end
    
  context "class method accept_appointment_for_user_hours" do
    before(:each) do 
       @user_a = FactoryGirl.create(:user)
       @user_b = FactoryGirl.create(:user)
       @start_time = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,10)+1.day
       @end_time = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,11)+1.day       
       @appointment_a = FactoryGirl.create(:appointment, :user=>@user_a, :start_time=>@start_time, :end_time=>@end_time)
       @appointment_b = FactoryGirl.create(:appointment, :user=>@user_b, :start_time=>@start_time, :end_time=>@end_time)

       @recipient_appointment = RecipientAppointment.create(:user=>@user_b, :appointment=>@appointment_a)             
    end
    
    it "changes the group hour to the accepted appointment" do
      group_hour_a = @appointment_a.user_hours.first.group_hour
      group_hour_b = @appointment_b.user_hours.first.group_hour
      puts "group_hour_a=#{group_hour_a.id}"
      puts "group_hour_b=#{group_hour_b.id}"
      group_hour_a.should_not eq(group_hour_b)
      
    #  UserHour.all.each do |u| puts "#{u.id}->#{u.group_hour.id}"  end  
      Appointment.accept_appointment_for_user_hours(@user_b,@appointment_a)
  #    UserHour.all.each do |u| puts "#{u.id}->#{u.group_hour.id}"  end  

      #puts "@appointment_b.user_hours = #{@appointment_b.user_hours.to_yaml}"
      @appointment_b.user_hours.first.reload
      group_hour_b = @appointment_b.user_hours.first.group_hour
      group_hour_a.should eq(group_hour_b)
    end
    it "does not change the group hour if it has already an accepted appointment" do
      # user b accepts an appointment of user c
      # user a sends b another appointment
      user_c = FactoryGirl.create(:user)
      appointment_c = FactoryGirl.create(:appointment, :user=>user_c, :start_time=>@start_time, :end_time=>@end_time)
      RecipientAppointment.create(:user=>@user_b, :appointment=>appointment_c)
      Appointment.accept_appointment_for_user_hours(@user_b,appointment_c)

      group_hour_a = @user_a.user_hours.first.group_hour
      group_hour_b = @user_b.user_hours.first.group_hour
      group_hour_c = user_c.user_hours.first.group_hour
      
      group_hour_b.should_not eq(group_hour_a)
      group_hour_b.should eq(group_hour_c)
      
      Appointment.accept_appointment_for_user_hours(@user_b,@appointment_a)
      @user_b.user_hours.first.reload
      group_hour_b = @user_b.user_hours.first.group_hour
      group_hour_b.should_not eq(group_hour_a)
      group_hour_b.should eq(group_hour_c)
    end    
    
  end
    
   
  
   
   context "when accepting a received_appointment the user_hours are generated" do    
      before(:each) do 
         @user_a = FactoryGirl.create(:user)
         @user_b = FactoryGirl.create(:user)
         @appointment_a = FactoryGirl.create(:appointment, :user=>@user_a)
         @recipient_appointment = RecipientAppointment.create(:user=>@user_b, :appointment=>@appointment_a)         
         
      end  
      
      it "should create an appointment of 2 hours if accepting a received appointment of 2 hours" do
        appointments = Appointment.accept_received_appointment(@user_b,@appointment_a )
        appointment = appointments.first
        appointment.should_not be_nil
        appointment.should_not eq(@appointment_a)
        (appointment.start_time+2.hours).should eq(appointment.end_time)
      end
      
      it "should create two user_hours for a 2 hour appointment" do
        appointments = Appointment.accept_received_appointment(@user_b,@appointment_a )
        appointment = appointments.first
         appointment.user_hours.count.should eq(2)
      end  
      
      it "should have user_hours with the same GroupHour" do
        appointments = Appointment.accept_received_appointment(@user_b,@appointment_a )
        appointment = appointments.first
         group_hours = appointment.user_hours.map(&:group_hour)
         group_hours.should eq(@appointment_a.user_hours.map(&:group_hour))
      end      
      
      it "should raise an error when accepting its own appointment" do
         lambda {
           appointments = Appointment.accept_received_appointment(@user_a,@appointment_a )
         }.should raise_error
      end    
      
      it "should raise an error when appointment was not received" do
        @recipient_appointment.destroy
         lambda {
           appointments = Appointment.accept_received_appointment(@user_a,@appointment_a )
         }.should raise_error
      end        
        
    end
end
