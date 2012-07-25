# == Schema Information
#
# Table name: cameras
#
#  id               :integer         not null, primary key
#  user_id          :integer
#  success          :boolean
#  dont_show_info   :boolean
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#  dont_show_wizard :boolean
#

require 'test_helper'

class CameraTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
