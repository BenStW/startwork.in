class AddRoomToWorkSessions < ActiveRecord::Migration
  def change
    add_column :work_sessions, :room_id, :integer

  end
end
