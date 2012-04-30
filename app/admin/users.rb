ActiveAdmin.register User do
  menu :priority => 1 #, :parent => "User Administration"
  
  filter :first_name
  filter :last_name
  
  filter :email
  filter :referer  
  
  index do
      column :id
      column :name
      column :email
      column :referer        
      column :connections do |user|
        user.connections.count
#        link_to user.connections.count, admin_connections_path
       # link_to "Ruby on Rails search", :controller => "admin_connections", :query => "ruby on rails"
      end
      column "created at", :created_at
      column "last sign in at", :last_sign_in_at
      column "sign in count", :sign_in_count  
      column "Action" do |user|
        link_to 'Impersonate', impersonate_admin_user_path(user)
      end      
      default_actions
    end
    
    
    form do |f|
    
      f.inputs "User Details - not to be changed" do
        f.input :id
        f.input :first_name
        f.input :last_name        
        f.input :email
      end
      f.buttons
    end
    
    show do 
      h3 user.name
      attributes_table :id, :email
      h2 link_to "CalendarEvents", admin_calendar_events_path
    end
    
    member_action :impersonate do
        sign_in(:user, User.find(params[:id]))
        redirect_to root_path
    end
  
end
