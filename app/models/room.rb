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

  has_many :work_sessions, :dependent => :destroy
  
  def self.tokbox_session_id_filled?
    where("tokbox_session_id is not ?",nil)
  end
  
# def tokbox_session_id    
#  # puts "**** tokbox_session_id for user #{self.user.first_name}"
#   if @tokbox_session_id.nil?
#  #   puts "**** CREATE tokbox_session_id for user #{self.user.name}"
#     @tokbox_session_id = (TokboxApi.instance.generate_session self.user.current_sign_in_ip).to_s
#     self.save
#   end
#   @tokbox_session_id 
# end
  
end
