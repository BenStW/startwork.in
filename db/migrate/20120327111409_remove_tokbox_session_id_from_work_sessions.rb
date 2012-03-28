class RemoveTokboxSessionIdFromWorkSessions < ActiveRecord::Migration
  def up
    remove_column :work_sessions, :tokbox_session_id
      end

  def down
    add_column :work_sessions, :tokbox_session_id, :string
  end
end
