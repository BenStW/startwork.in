class CreateWorkSessions < ActiveRecord::Migration
  def change
    create_table :work_sessions do |t|
      t.string :tokbox_session_id

      t.timestamps
    end
  end
end
