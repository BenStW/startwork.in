class RequestsController < ApplicationController
  
  def create
    puts "********** RequestsController.create **********"
    puts params.to_yaml
    request_str = params[:request_str]
    appointment = current_user.appointments.find(params[:appointment_id])
    puts "found appointment #{appointment.id}"
    
    request = Request.create(:request_str=>request_str, :appointment_id=>appointment.id)
    puts "request valid? #{request.valid?}"
    puts "request errors #{request.errors.to_yaml}"
    
    if request.valid?
       render :json => "ok"
     else
       render :template => "errors/404", :layout => 'application', :status => 404    
     end
  end
  
end
