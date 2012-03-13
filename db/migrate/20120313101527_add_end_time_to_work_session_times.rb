class AddEndTimeToWorkSessionTimes < ActiveRecord::Migration
  def change
    add_column :work_session_times, :end_time, :datetime

  end
end
