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

require 'spec_helper'

describe CameraAudio do
  pending "add some examples to (or delete) #{__FILE__}"
end
