class AddUserToWorkSessionTimes < ActiveRecord::Migration
  def change
    add_column :work_session_times, :user_id, :integer

  end
end
