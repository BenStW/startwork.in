class CreateUserHours < ActiveRecord::Migration
  def change
    create_table :user_hours do |t|
      t.integer :user_id      
      t.datetime :start_time
      t.integer :group_hour_id
      t.integer :appointment_id
      t.integer :accepted_appointment_id
      t.datetime :login_time
      t.integer :login_count
      t.timestamps
    end
  end
end
