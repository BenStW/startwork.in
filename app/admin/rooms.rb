ActiveAdmin.register Room do
    menu :priority => 12
  filter :user


  index do
       h2 "'Rooms' sind die Raeume der Arbeitsgruppen."
       h3 "Jeder User besitzt genau einen Raum."
      column :id
      column :user
      column :tokbox_session_id
    end
end
