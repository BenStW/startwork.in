class CreateCalendarEvents < ActiveRecord::Migration
  def change
    create_table :calendar_events do |t|
      t.references :user
      t.datetime :start_time

      t.timestamps
    end        
    add_index :calendar_events, :user_id
    
    work_session_times = WorkSessionTime.all
     work_session_times.each do |work_session_time|
       user = work_session_time.user
       start_time = work_session_time.start_time
       user.calendar_events.create(:start_time => start_time)
     end
  end

end
