class AddStartTimeToWorkSessions < ActiveRecord::Migration
  def change
    add_column :work_sessions, :start_time, :datetime

  end
end
