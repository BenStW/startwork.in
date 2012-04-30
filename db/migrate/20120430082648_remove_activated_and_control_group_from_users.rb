class RemoveActivatedAndControlGroupFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :activated
        remove_column :users, :control_group
      end

  def down
    add_column :users, :control_group, :boolean
    add_column :users, :activated, :boolean
  end
end
