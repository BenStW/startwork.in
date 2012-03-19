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
#  user_id         :integer
#

class WorkSessionTime < ActiveRecord::Base
   validates :user_id, :start_time, :end_time, :presence => true
    
 # belongs_to :work_session
  belongs_to :user
end
