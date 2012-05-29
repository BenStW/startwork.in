class AddFbUiToUsers < ActiveRecord::Migration
  def change
    add_column :users, :fb_ui, :string

  end
end
