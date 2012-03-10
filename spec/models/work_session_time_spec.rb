# == Schema Information
#
# Table name: work_session_times
#
#  id              :integer         not null, primary key
#  work_session_id :integer
#  start_time      :datetime
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

require 'spec_helper'

describe WorkSessionTime do
  pending "add some examples to (or delete) #{__FILE__}"
end
