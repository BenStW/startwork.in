class CreatePenalties < ActiveRecord::Migration
  def change
    create_table :penalties do |t|
      t.integer :from_user_id
      t.integer :to_user_id
      t.string :excuse

      t.timestamps
    end
  end
end
