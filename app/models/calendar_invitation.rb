# == Schema Information
#
# Table name: calendar_invitations
#
#  id         :integer         not null, primary key
#  sender_id  :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class CalendarInvitation < ActiveRecord::Base
  belongs_to :sender, :class_name => 'User'

  validates:sender_id, presence: true

    
end
