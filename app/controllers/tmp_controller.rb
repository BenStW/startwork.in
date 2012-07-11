class TmpController < ApplicationController

  def index
   @my_appointments = current_user.appointments  
    @my_user_hours = current_user.user_hours    
    
    @appointment = current_user.appointments.build   
    @recipient_appointment = RecipientAppointment.new
  end
  
  def create_appointment
   # a = Appointment.new(params[:appointment])
    a = current_user.appointments.create(params[:appointment])
    a.save
    redirect_to tmp_index_url   
  end
  
  def del_appointment
    a = current_user.appointments.find(params[:appointment])
    a.destroy
    redirect_to tmp_index_url  
  end
  
  def send_appointment
    puts "params = #{params[:recipient_appointment].to_yaml}"
    a=RecipientAppointment.create(params[:recipient_appointment])
  #  a = current_user.received_appointments.create(params[:recipient_appointment])
    puts "created = #{a.to_yaml}"
    redirect_to tmp_index_url  
  end  
  
end