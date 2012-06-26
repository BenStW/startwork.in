ActiveAdmin.register CalendarEvent do
    menu :priority => 10
    filter :user
    filter :start_time
    filter :login_count
    scope :this_week
    scope :after_logging_day
    scope :logged_in
    scope :not_logged_in
    scope :not_logged_in_this_week


    index do
         h2 "'Calendar Events' sind die Kalender-Eintraege der Benutzer"
        column :id
        column :user
        column "start_time" do |event | I18n.localize(event.start_time.in_time_zone("Berlin")) end
        column "login_time" do |event | I18n.localize(event.login_time.in_time_zone("Berlin")) if event.login_time end
        column :login_count        
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
