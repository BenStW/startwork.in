ActiveAdmin.register User do
  menu :priority => 1 , :parent => "User Administration"
  
  scope :registered?
  
  filter :first_name
  filter :last_name
  
  filter :email
  filter :referer  
  
  index do
      column :id
      column 'FB' do |user| raw "<img src='http://graph.facebook.com/#{user.fb_ui}/picture'" end       
      column :first_name
      column :last_name            
      column :name
      column :comment
      column "Facebook ID", :fb_ui
      column :email
      column :referer  
      column :registered      
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
        f.input :registered                    
        f.input :comment
      end
      f.buttons
    end
    
    show do 
      h3 user.name
      attributes_table :id, :first_name, :last_name, :comment
    end
    
    member_action :impersonate do
        sign_in(:user, User.find(params[:id]))
        redirect_to root_path
    end
  
end
