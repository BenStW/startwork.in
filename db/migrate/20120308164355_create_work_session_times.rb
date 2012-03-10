class CreateWorkSessionTimes < ActiveRecord::Migration
  def change
    create_table :work_session_times do |t|
      t.references :work_session
      t.datetime :start_time

      t.timestamps
    end
    add_index :work_session_times, :work_session_id
  end
end
