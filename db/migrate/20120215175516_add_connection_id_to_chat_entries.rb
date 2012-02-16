class AddConnectionIdToChatEntries < ActiveRecord::Migration
  def change
    add_column :chat_entries, :connectionId, :string

  end
end
