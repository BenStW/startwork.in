class AddSpontToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :spont, :boolean

  end
end
