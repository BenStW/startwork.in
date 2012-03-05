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

class Connection < ActiveRecord::Base
  belongs_to :user
  validates :user, :start_time, :presence => true   
  
  def duration 
    if end_time.nil?
      0
    else
      duration_in_seconds = end_time - start_time
      (duration_in_seconds/60).to_i
    end    
  end
end
