class CopyWorkSessionTimesToCalendarEvents < ActiveRecord::Migration
  def up
    work_session_times = WorkSessionTime.all
    work_session_times.each do |work_session_time|
       user = work_session_time.user
       start_time = work_session_time.start_time
       user.calendar_events.create(:start_time => start_time)
     end
  end

  def down
  end
end
