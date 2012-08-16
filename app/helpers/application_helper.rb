module ApplicationHelper
  
def if_active action_name
  'class=active' if controller.action_name == action_name
end

def fb_app
  #raw "<div id='fb-root' data-app='#{ FACEBOOK_CONFIG[:facebook][:app_key] }%>' style='position: absolute;'></div>"
  FACEBOOK_CONFIG[:facebook][:app_key] 
end

def load_facebook_jssdk
  
end



end
