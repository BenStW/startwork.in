class Room < ActiveRecord::Base
  belongs_to :user

  validates :tokbox_session_id, :presence => true
  #has_many :work_session_times, :dependent => :destroy
  before_validation :populate_tokbox_session  
  
  private
  
  def populate_tokbox_session
      
     if Rails.env == "test"
       #needed as the Session generation slows the test extremely down
       tokbox_session = "tokbox_session_id_test" 
     else
       tokbox_session = TokboxApi.instance.generate_session
     end
      self.tokbox_session_id=tokbox_session.to_s
     logger.info "Created Room #{self.id} for user #{self.user.id} with tokbox_session_id = #{self.tokbox_session_id}"
  end
  
end
