# == Schema Information
#
# Table name: work_sessions
#
#  id                :integer         not null, primary key
#  tokbox_session_id :string(255)
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#

class WorkSession < ActiveRecord::Base
  validates :tokbox_session_id, :presence => true
  has_many :work_session_times, :dependent => :destroy
  before_validation :create_tokbox_session
  
    
  def all_events_of_this_week
    c = DateTime.current
    today = DateTime.new(c.year,c.month,c.day)
    self.work_session_times.where("start_time >=?", today)
  end  

  
  private
  
  def create_tokbox_session
    if self.tokbox_session_id.nil?
      tokbox_session = TokboxApi.instance.generate_session
      self.tokbox_session_id=tokbox_session.to_s
      logger.info "Created WorkSession #{self.id} with tokbox_session_id = #{self.tokbox_session_id}"
    end
  end
  
  
end
