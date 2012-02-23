class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|
      t.references :user
      t.datetime :start
      t.datetime :end

      t.timestamps
    end
    add_index :connections, :user_id
  end
end
