# == Schema Information
#
# Table name: chat_entries
#
#  id            :integer         not null, primary key
#  group_id      :integer
#  body          :text
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#  connection_id :string(255)
#

require 'test_helper'

class ChatEntryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
