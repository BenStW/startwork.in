class AddConnectIdToChatEntries < ActiveRecord::Migration
  def change
    add_column :chat_entries, :connection_id, :string

  end
end
