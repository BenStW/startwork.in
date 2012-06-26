class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.integer :sender_id
      t.datetime :start_time
      t.datetime :end_time
      t.string :token

      t.timestamps
    end
  end
end
