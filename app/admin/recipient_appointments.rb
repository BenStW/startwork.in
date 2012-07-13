ActiveAdmin.register RecipientAppointment do
    menu :priority => 10
    filter :user
    filter :appointment


    index do
         h2 "'RecipientAppointments' sind die empfangenen Verabredungen."
         column :id
         column "Sender" do |recipient_appointment | recipient_appointment.user.name end     
         column "Empfaenger", :user
         column "(empfangene) Verabredung" do |recipient_appointment | recipient_appointment.appointment.id end     
         default_actions           
      end
end
