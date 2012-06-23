class AddCommentToUser < ActiveRecord::Migration
  def change
    add_column :users, :comment, :string

  end
end
