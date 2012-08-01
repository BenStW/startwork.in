ActiveAdmin.register RecipientAppointment do
    menu :priority => 10
    filter :user
    filter :appointment_id
    filter :accepted, :as => :select

    index do
         h2 "'RecipientAppointments' sind die empfangenen Verabredungen."
         column :id
         column "Empfaenger", :user
         column "(empfangene) Verabredung" do |recipient_appointment | recipient_appointment.appointment.id end     
         column :accepted
         column :accepted_on
         default_actions           
      end
end
