ActiveAdmin.register CalendarInvitation do
  menu :priority => 10
  filter :sender

  index do
       h2 "'Calendar Invitation' ist das Senden einer Einladung aus dem Kalendar."
      column :id
      column :sender 
      column :created_at       
    end
end
