class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer :appointment_id
      t.string :request_str

      t.timestamps
    end
  end
end
