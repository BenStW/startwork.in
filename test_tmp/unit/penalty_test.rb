# == Schema Information
#
# Table name: penalties
#
#  id           :integer         not null, primary key
#  from_user_id :integer
#  to_user_id   :integer
#  excuse       :string(255)
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#

require 'test_helper'

class PenaltyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
