class AddStartAndEndTimesToConnections < ActiveRecord::Migration
  def change
    add_column :connections, :start_time, :datetime

    add_column :connections, :end_time, :datetime

  end
end
