class AddStartAndEndTimeToPenalty < ActiveRecord::Migration
  def change
    add_column :penalties, :start_time, :datetime

    add_column :penalties, :end_time, :datetime

  end
end
