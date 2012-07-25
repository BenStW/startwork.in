class RemoveTokenFromAppointments < ActiveRecord::Migration
  def up
    remove_column :appointments, :token
      end

  def down
    add_column :appointments, :token, :string
  end
end
