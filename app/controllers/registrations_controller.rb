class RegistrationsController < Devise::RegistrationsController
  def new
    super
  end

  def create
    super
    if current_user
      current_user.build_room
      current_user.save_referer(session[:referer])
    end
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