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
  context "attributes" do
    before(:each) do
      @camera_audio = FactoryGirl.build(:camera_audio)
    end
    
    it "is valid with attributes of factory " do
      @camera_audio.should be_valid
    end
    
    it "is not valid without an user" do
      @camera_audio.user = nil
      @camera_audio.should_not be_valid
    end
    
    it "stores video success per user" do
      @camera_audio.video_success = true
      @camera_audio.should be_valid
    end
    
    it "stores audio success per user" do
      @camera_audio.audio_success = true
      @camera_audio.should be_valid
    end
      
      
    
  end
end
