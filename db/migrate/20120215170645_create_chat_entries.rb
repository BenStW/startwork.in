class CreateChatEntries < ActiveRecord::Migration
  def change
    create_table :chat_entries do |t|
      t.integer :group_id
      t.text :body
      t.string :connection_id

      t.timestamps
    end
  end
end
