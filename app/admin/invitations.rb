ActiveAdmin.register Invitation do
    menu :priority => 4, :parent => "User Administration"
  filter :sender
  
  index do
  
      column :id
      column :sender
      column :recipient_mail 
    end
end
