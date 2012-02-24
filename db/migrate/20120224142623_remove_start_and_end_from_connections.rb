class RemoveStartAndEndFromConnections < ActiveRecord::Migration
  def up
    remove_column :connections, :start
        remove_column :connections, :end
      end

  def down
    add_column :connections, :end, :datetime
    add_column :connections, :start, :datetime
  end
end
