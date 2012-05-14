class CreateCalendarInvitations < ActiveRecord::Migration
  def change
    create_table :calendar_invitations do |t|
      t.integer :sender_id

      t.timestamps
    end
  end
end
