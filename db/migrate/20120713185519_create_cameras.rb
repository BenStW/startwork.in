class CreateCameras < ActiveRecord::Migration
  def change
    create_table :cameras do |t|
      t.integer :user_id
      t.boolean :success
      t.boolean :dont_show_info

      t.timestamps
    end
  end
end
