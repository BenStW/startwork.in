class CreateUserCopies < ActiveRecord::Migration
  def change
    create_table :user_copies do |t|
      t.integer :id_orig
      t.string :email
      t.string :encrypted_password
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.integer :sign_in_count
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at    
      t.string :current_sign_in_ip 
      t.string :last_sign_in_ip    
      t.datetime :created_at         
      t.datetime :updated_at         
      t.string :referer            
      t.string :first_name         
      t.string :last_name          
      t.string :fb_ui              
      

      t.timestamps
    end
  end
  
   def up
     User.all.each do |user|
       user_copy = UserCopy.new
       user_copy.id_orig=user.id
       user_copy.email = user.email
       user_copy.encrypted_password    =user.encrypted_password
       user_copy.reset_password_token  =user.reset_password_token
       user_copy.reset_password_sent_at=user.reset_password_sent_at
       user_copy.remember_created_at   =user.remember_created_at
       user_copy.sign_in_count         =user.sign_in_count
       user_copy.current_sign_in_at    =user.current_sign_in_at
       user_copy.last_sign_in_at    = user.last_sign_in_at   
       user_copy.current_sign_in_ip = user.current_sign_in_ip
       user_copy.last_sign_in_ip    = user.last_sign_in_ip   
       user_copy.created_at         = user.created_at        
       user_copy.updated_at         = user.updated_at        
       user_copy.referer            = user.referer           
       user_copy.first_name         = user.first_name        
       user_copy.last_name          = user.last_name         
       user_copy.fb_ui              = user.fb_ui                             
       user_copy.save               
    end
  end
end   