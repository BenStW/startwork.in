module ApplicationHelper
  
def if_active action_name
  'class=active' if controller.action_name == action_name
end

def login_or_signup
  if user_signed_in?
     current_user.email
   else
     link_to "sign in", new_user_session_path
   end
end

end
