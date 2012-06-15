class AddLoginTimeToConnections < ActiveRecord::Migration
  def change
    add_column :connections, :login_time, :datetime

    add_column :connections, :login_count, :integer

  end
end
