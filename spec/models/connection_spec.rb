# == Schema Information
#
# Table name: connections
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  start_time :datetime
#  end_time   :datetime
#

require 'spec_helper'

describe Connection do
  pending "add some examples to (or delete) #{__FILE__}"
end
