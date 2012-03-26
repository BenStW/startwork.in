class RegistrationsController < Devise::RegistrationsController
  def new
    super
  end

  def create
    super
    logger.info "********* Own RegistrationsController ********"
    current_user.save_referer(session[:referer])
    logger.info "********* saved  #{session[:referer]} as referer ********"
  end
  
  def edit
    super
  end  

  def update
    super
  end
  
  def destroy
    super
  end
  
  def cancel
    super
  end
  

  
  
end