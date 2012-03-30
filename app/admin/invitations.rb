ActiveAdmin.register Invitation do
    menu :priority => 3
  filter :sender
  
  index do
  
      column :id
      column :sender
      column :recipient_mail 
    end
end
