class RemoveConIdFromChatEntries < ActiveRecord::Migration
  def up
    remove_column :chat_entries, :connectionId
      end

  def down
    add_column :chat_entries, :connectionId, :string
  end
end
