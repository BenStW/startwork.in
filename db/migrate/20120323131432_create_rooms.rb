class CreateRooms < ActiveRecord::Migration
  def up
    create_table :rooms do |t|
      t.references :user
      t.string :tokbox_session_id

      t.timestamps
    end
   add_index :rooms, :user_id
   
   User.all.each do |user|
     user.create_room
   end
  end
  
  def down
    drop_table :rooms    
  end
end
