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
  
  def after_initialize
   # logger.info "after initialize"
  end 
  
  def tokbox_api_key
    11796762
  end
  
  def tokbox_api_secret
    'f6989f3520873c70f414edfd3f5d02e88ab4a97b'
  end

  def generate_tokbox_session(remote_addr = "0.0.0.0")
    tokbox_session = tokbox_api_obj.create_session(remote_addr)      
    self.tokbox_session_id  = tokbox_session.session_id      
    logger.info "Created tokbox_session for session #{id}"  
    self.tokbox_session_id     
  end
  
  def generate_tokbox_token(connection_data)
    if(connection_data[:user_id].nil? || connection_data[:user_name].nil?)
      raise "To generate a tokbox token the connection data must contain the user_id and user_name"
    end
    tokbox_api_obj.generate_token session_id: tokbox_session_id, connection_data: connection_data.to_json
  end
  
  private
  
  def tokbox_api_obj
    @tokbox_api_obj ||= OpenTok::OpenTokSDK.new tokbox_api_key, tokbox_api_secret  
  end
  
end
