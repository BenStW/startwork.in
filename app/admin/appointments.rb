ActiveAdmin.register Appointment do
    menu :priority => 10
    filter :sender
    filter :start_time
    filter :end_time
    filter :send_count
    filter :receive_count


    index do
         h2 "'Appointments' sind Verabredungen. Es kann leider nicht gespeichert werden, ob und an wen ein Benutzer die Verabredung geschickt hat."
        column :id
        column :sender
        column "start_time" do |appointment | I18n.localize(appointment.start_time.in_time_zone("Berlin")) end
        column "end_time" do |appointment | I18n.localize(appointment.end_time.in_time_zone("Berlin")) end
        column :token
        column :send_count        
        column :receive_count        
      end
end
