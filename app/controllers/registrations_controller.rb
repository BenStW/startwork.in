class RegistrationsController < Devise::RegistrationsController
  def new
    super
  end

  def create
    super
    if current_user
      room = current_user.build_room
      room.populate_tokbox_session 
      current_user.referer = session[:referer]
      current_user.save
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