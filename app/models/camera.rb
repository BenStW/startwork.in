# == Schema Information
#
# Table name: cameras
#
#  id             :integer         not null, primary key
#  user_id        :integer
#  success        :boolean
#  dont_show_info :boolean
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

class Camera < ActiveRecord::Base
    belongs_to :user
    validates :user, :presence => true

    scope :problems,( lambda do 
      where("success = false")
    end)
  end
