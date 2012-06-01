ActiveAdmin.register UserCopy do
  menu :priority => 1 , :parent => "User Administration"
  
  filter :first_name
  filter :last_name
  
  filter :email
  filter :referer  
  
  index do
      column :id
      column :id_orig      
      column :first_name
      column :last_name            
      column :email
      column :referer        
      column "created at", :created_at
      column "last sign in at", :last_sign_in_at
      column "sign in count", :sign_in_count  
    end
end
