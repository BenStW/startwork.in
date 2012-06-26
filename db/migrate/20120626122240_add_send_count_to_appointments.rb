class AddSendCountToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :send_count, :integer

    add_column :appointments, :receive_count, :integer

  end
end
