ActiveAdmin.register Appointment do
    menu :priority => 10
    filter :user
    filter :start_time
    filter :end_time
    filter :send_count
    filter :receive_count


    index do
         h2 "'Appointments' sind Verabredungen. Es kann leider nicht gespeichert werden, ob und an wen ein Benutzer die Verabredung geschickt hat."
        column :id
        column :user
        column "start_time" do |appointment | I18n.localize(appointment.start_time.in_time_zone("Berlin")) unless appointment.start_time.nil? end
        column "end_time" do |appointment | I18n.localize(appointment.end_time.in_time_zone("Berlin")) unless appointment.start_time.nil? end
        column :token
        column :send_count        
        column :receive_count        
      end
end
