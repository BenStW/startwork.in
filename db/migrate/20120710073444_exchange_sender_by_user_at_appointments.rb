class ExchangeSenderByUserAtAppointments < ActiveRecord::Migration
  def up
    remove_column :appointments, :sender_id
    add_column :appointments, :user_id, :integer    
   end

  def down
    add_column :appointments, :sender_id, :integer
    remove_column :appointments, :user_id
  end
end
