# == Schema Information
#
# Table name: work_session_times
#
#  id              :integer         not null, primary key
#  work_session_id :integer
#  start_time      :datetime
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  end_time        :datetime
#

class WorkSessionTime < ActiveRecord::Base
  belongs_to :work_session
end
