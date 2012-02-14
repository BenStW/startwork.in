# == Schema Information
#
# Table name: rooms
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  session_id :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Room < ActiveRecord::Base
  
end
