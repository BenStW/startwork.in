module ApplicationHelper
  
def if_active action_name
  'class=active' if controller.action_name == action_name
end



end
