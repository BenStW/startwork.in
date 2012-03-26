# == Schema Information
#
# Table name: invitations
#
#  id             :integer         not null, primary key
#  sender_id      :integer
#  recipient_mail :string(255)
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

require 'spec_helper'

describe Invitation do
  pending "add some examples to (or delete) #{__FILE__}"
end
