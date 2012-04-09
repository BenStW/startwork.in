# == Schema Information
#
# Table name: camera_audios
#
#  id            :integer         not null, primary key
#  user_id       :integer
#  video_success :boolean
#  audio_success :boolean
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#

class CameraAudio < ActiveRecord::Base
  belongs_to :user
  
  scope :problems,( lambda do 
    where("video_success = false or audio_success = false")
  end)
end
