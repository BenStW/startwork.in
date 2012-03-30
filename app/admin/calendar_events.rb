ActiveAdmin.register CalendarEvent do
    menu :priority => 10
    filter :user
    filter :start_time
    filter :work_session 
    scope :this_week


    index do
         h2 "'Calendar Events' sind die Kalender-Eintraege der Benutzer"
        column :id
        column :user
        column :start_time
        column :work_session do |calendar_event|
          link_to calendar_event.work_session_id, admin_work_session_path(calendar_event.work_session)  
          end
        column :users do |calendar_event|
          #          names = calendar_event.work_session.users.map(&:name).join(" - ")
          names = ""
          calendar_event.work_session.users.each do |user|
            names += raw(link_to user.name, admin_user_path(user.id)) + " "
          end
           raw(names)
          end                
      end
end
