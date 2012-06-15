class AddLoginTimeToCalendarEvents < ActiveRecord::Migration
  def change
    add_column :calendar_events, :login_time, :datetime

    add_column :calendar_events, :login_count, :integer

  end
end
