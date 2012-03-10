class AddActivatedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :activated, :boolean

  end
end
