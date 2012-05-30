class AddGuestToWorkSession < ActiveRecord::Migration
  def change
    add_column :work_sessions, :guest_id, :integer

  end
end
