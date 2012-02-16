class RemoveConnectionIdFromChatEntries < ActiveRecord::Migration
  def change
        remove_column :chat_entries, :connectionId
  end

end
