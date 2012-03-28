class AddWorkSessionToCalendarEvents < ActiveRecord::Migration
  def change
    add_column :calendar_events, :work_session_id, :integer

  end
end
