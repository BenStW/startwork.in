# == Schema Information
#
# Table name: appointments
#
#  id            :integer         not null, primary key
#  sender_id     :integer
#  start_time    :datetime
#  end_time      :datetime
#  token         :string(255)
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#  send_count    :integer
#  receive_count :integer
#

class Appointment < ActiveRecord::Base
  belongs_to :sender, :class_name => 'User'
  validates :sender, presence: true
    
  before_create :generate_token 
  after_initialize :init    
  
  def init
    self.send_count ||= 0
    self.receive_count ||= 0
  end  
  
  def generate_token
    self.token = Digest::SHA1.hexdigest([Time.now, rand].join)
  end


end
