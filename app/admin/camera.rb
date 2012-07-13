ActiveAdmin.register Camera do
   menu :priority => 2
   
   filter :user
   filter :success
   filter :dont_show_info
   scope  :problems

   index do
       h2 "Camera Test"
       column :user
       column :success
       column :dont_show_info
       default_actions       
     end
   
end
