class CreateGroupHours < ActiveRecord::Migration
  def change
    create_table :group_hours do |t|
      t.datetime :start_time
      t.string :tokbox_session_id

      t.timestamps
    end
  end
end
