ActiveAdmin.register Appointment do
    menu :priority => 10
    filter :id    
    filter :user
    filter :start_time
    filter :spont, :as => :select
    scope  :this_week        
    scope  :current        



    index do
         h2 "'Appointments' sind Verabredungen. Es kann leider nicht gespeichert werden, ob und an wen ein Benutzer die Verabredung geschickt hat."
        column :id
        column :user
        column "start_time" do |appointment | I18n.localize(appointment.start_time.in_time_zone("Berlin")) unless appointment.start_time.nil? end
        column "end_time" do |appointment | I18n.localize(appointment.end_time.in_time_zone("Berlin")) unless appointment.start_time.nil? end
        column :spont          
        column :send_count        
        column :receive_count  
        default_actions      
      end
end
