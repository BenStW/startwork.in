ActiveAdmin.register GroupHour do
    menu :priority => 11
  filter :start_time
  scope :this_week  
  scope :current


  index do
       h2 "'GroupHours' sind Arbeitsgruppen"
       h3 "- zu einer bestimmten Zeit (start_time) fuer eine Stunde"
       h3 "- mit bestimmten Benutzern"
      column :id
      column "start_time" do |group_hour | I18n.localize(work_session.start_time.in_time_zone("Berlin")) end
      column :users do |group_hour|
          #names = work_session.users.map(&:name).join(" - ")
          names = ""
          group_hour.users.each do |user|
            names += raw(link_to user.name, admin_user_path(user.id)) + " "
          end
           raw(names)
        end         
      default_actions        
    end
end
