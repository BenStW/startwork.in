class AddAcceptedToRecipientAppointments < ActiveRecord::Migration
  def change
    add_column :recipient_appointments, :accepted, :boolean

    add_column :recipient_appointments, :accepted_on, :datetime

  end
end
