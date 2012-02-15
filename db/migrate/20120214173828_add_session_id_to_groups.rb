class AddSessionIdToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :session_id, :string

  end
end
