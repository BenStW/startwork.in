# = General Information
# 

# == Schema Information
#
# Table name: rooms
#
#  id                :integer         not null, primary key
#  user_id           :integer
#  tokbox_session_id :string(255)
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#

class Room < ActiveRecord::Base
  belongs_to :user #host

  validates :tokbox_session_id, :presence => true
  has_many :work_sessions, :dependent => :destroy
  
  before_validation :populate_tokbox_session
  
  def populate_tokbox_session    
    if  self.tokbox_session_id.nil?    
      begin
         ip_address = self.user.current_sign_in_ip
         tokbox_session = TokboxApi.instance.generate_session ip_address
         self.tokbox_session_id=tokbox_session.to_s         
         logger.info "Created Room #{self.id} for user #{self.user.id} with tokbox_session_id = #{self.tokbox_session_id}"         
      rescue Timeout::Error
         tokbox_session = "Timeout::Error -> no tokbox_session"
         logger.error "Timeout:Error -> Room #{self.id} for user #{self.user.id} without tokbox_session"        
      end
    end
 end
  
end
