class AddControlGroupToUsers < ActiveRecord::Migration
  def change
    add_column :users, :control_group, :boolean

  end
end
