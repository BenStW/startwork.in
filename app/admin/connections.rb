ActiveAdmin.register Connection do
    menu :priority => 20
  filter :user
  
  index do
      column :id
      column :user
      column :start_time
      column :end_time
      column :duraction do |connection|
             connection.duration
        end      
    end
    
end
