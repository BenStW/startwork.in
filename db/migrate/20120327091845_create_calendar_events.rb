class CreateCalendarEvents < ActiveRecord::Migration
  def change
    create_table :calendar_events do |t|
      t.references :user
      t.datetime :start_time

      t.timestamps
    end        
    add_index :calendar_events, :user_id
    

  end

end
