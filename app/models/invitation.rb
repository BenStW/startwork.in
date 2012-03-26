# == Schema Information
#
# Table name: invitations
#
#  id             :integer         not null, primary key
#  sender_id      :integer
#  recipient_mail :string(255)
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

class Invitation < ActiveRecord::Base
  belongs_to :sender, :class_name => 'User'
#  has_one :recipient, :class_name => 'User'

  validates :recipient_mail, :sender_id, presence: true
  validates_format_of :recipient_mail,
    :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i  
#  validate :recipient_is_not_registered  
  
  private

# def recipient_is_not_registered
#   errors.add :recipient_email, 'is already registered' if User.find_by_email(recipient_email)
# end

  
end
