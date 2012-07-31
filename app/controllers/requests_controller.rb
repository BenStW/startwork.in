class RequestsController < ApplicationController
  
  def create
    request_str = params[:request_str]
    appointment = current_user.appointments.find(params[:appointment_id])
    
    request = Request.create(:request_str=>request_str, :appointment_id=>appointment.id)
    
    if request.valid?
       render :json => "ok"
     else
       render :template => "errors/404", :layout => 'application', :status => 404    
     end
  end
  
end
