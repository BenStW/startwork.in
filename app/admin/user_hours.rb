ActiveAdmin.register UserHour do
    menu :priority => 10
    filter :id
    filter :user
    filter :start_time
    filter :login_count
    
    scope :this_week
    scope  :scope_current  
     
    scope :logged_in
    scope :not_logged_in

    index do
         h2 "'User_Hours' sind die Termine der Benutzer pro Stunde"
        column :id
        column :user
        column "start_time" do |user_hour | I18n.localize(user_hour.start_time.in_time_zone("Berlin")) end
        column :appointment_id 
        column :accepted_appointment_id       
        column "login_time" do |user_hour | I18n.localize(user_hour.login_time.in_time_zone("Berlin")) if user_hour.login_time end
        column :login_count        
        column :group_hour do |user_hour|
           link_to user_hour.group_hour_id, admin_group_hour_path(user_hour.group_hour)  unless user_hour.group_hour.nil?
          end
        column :users do |user_hour|
          #          names = calendar_event.work_session.users.map(&:name).join(" - ")
          names = ""
          if !user_hour.group_hour.nil?
            user_hour.group_hour.users.each do |user|
              names += raw(link_to user.name, admin_user_path(user.id)) + " "
            end
          end
           raw(names)
          end 
          default_actions               
      end
end
