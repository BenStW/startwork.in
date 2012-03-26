ActiveAdmin.register Invitation do
  filter :sender
  
  index do
      column :id
      column :sender
      column :recipient_mail 
    end
end
