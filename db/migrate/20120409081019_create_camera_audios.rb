class CreateCameraAudios < ActiveRecord::Migration
  def change
    create_table :camera_audios do |t|
      t.references :user
      t.boolean :video_success
      t.boolean :audio_success

      t.timestamps
    end
    add_index :camera_audios, :user_id
  end
end
