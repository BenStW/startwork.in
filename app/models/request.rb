# == Schema Information
#
# Table name: requests
#
#  id             :integer         not null, primary key
#  appointment_id :integer
#  request_str    :string(255)
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#


class Request < ActiveRecord::Base
  
  belongs_to :appointment

  validates :appointment,  :request_str, presence: true
end
