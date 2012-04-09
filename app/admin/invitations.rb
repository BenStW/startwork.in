ActiveAdmin.register Invitation do
    menu :priority => 4
  filter :sender
  
  index do
  
      column :id
      column :sender
      column :recipient_mail 
    end
end
