ActiveAdmin.register User do
  filter :name
  filter :email
  scope :not_activated
  
  
  index do
      column :id
      column :name
      column :email
      column :connections do |user|
        user.connections.count
#        link_to user.connections.count, admin_connections_path
       # link_to "Ruby on Rails search", :controller => "admin_connections", :query => "ruby on rails"
      end
      column "created at", :created_at
      column "last sign in at", :last_sign_in_at
      column "sign in count", :sign_in_count
      column :activated
      default_actions
    end
    
    
    form do |f|
    
      f.inputs "User Details - not to be changed" do
        f.input :id
        f.input :name
        f.input :email
      end
      f.inputs "User Details - can be changed" do
        f.input :activated
      end
      f.buttons
    end
    
    show do
      h3 user.name
      attributes_table :id, :email, :activated 
    end
    
  
end
