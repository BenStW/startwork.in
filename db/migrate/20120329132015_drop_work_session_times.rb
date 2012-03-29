class DropWorkSessionTimes < ActiveRecord::Migration
  def change
    drop_table :work_session_times 
  end
end
