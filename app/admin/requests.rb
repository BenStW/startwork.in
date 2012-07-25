ActiveAdmin.register Request do
    menu :priority => 10
    filter :id    
    filter :appointment_id
    filter :request_str

    index do
         h2 "'Requests' sind Facebook Request zu einem Appointment"
        column :id
        column :appointment_id
        column :request_str
        default_actions      
      end
end
