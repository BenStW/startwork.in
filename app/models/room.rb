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
  #has_many :work_session_times, :dependent => :destroy
  has_many :work_sessions
  before_validation :populate_tokbox_session
  
  private
  
  def populate_tokbox_session    
    if  self.tokbox_session_id.nil?    
      if Rails.env == "test"
         #needed as the Session generation slows the test extremely down
         tokbox_session = "tokbox_session_id_test" 
       else
         begin
           ip_address = self.user.current_sign_in_ip
           tokbox_session = TokboxApi.instance.generate_session ip_address
         rescue Timeout::Error
           tokbox_session = "Timeout::Error -> no tokbox_session"
           logger.error "Timeout:Error -> Room #{self.id} for user #{self.user.id} without tokbox_session"        
         end
       end
        self.tokbox_session_id=tokbox_session.to_s
        logger.info "Created Room #{self.id} for user #{self.user.id} with tokbox_session_id = #{self.tokbox_session_id}"
     end
 end
  
end
