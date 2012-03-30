ActiveAdmin.register WorkSession do
    menu :priority => 11
  filter :start_time
  scope :this_week


  index do
       h2 "'Work Sessions' sind Arbeitsgruppen"
       h3 "- zu einer bestimmten Zeit (start_time) fuer eine Stunde"
       h3 "- mit bestimmten Benutzern"
       h3 "- in einem bestimmten Raum"
      column :id
      column :start_time
      column :users do |work_session|
          #names = work_session.users.map(&:name).join(" - ")
          names = ""
          work_session.users.each do |user|
            names += raw(link_to user.name, admin_user_path(user.id)) + " "
          end
           raw(names)
        end       
      column :room do |work_session|
        link_to work_session.room_id, admin_room_path(work_session.room)  
        end  
      column "host of room" do |work_session|
         user = work_session.room.user
          link_to user.name, admin_user_path(user)  
      end        
    end
end
