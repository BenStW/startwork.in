class CreateRecipientAppointments < ActiveRecord::Migration
  def change
    create_table :recipient_appointments do |t|
      t.integer :user_id
      t.integer :appointment_id

      t.timestamps
    end
  end
end
