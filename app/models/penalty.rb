# == Schema Information
#
# Table name: penalties
#
#  id           :integer         not null, primary key
#  from_user_id :integer
#  to_user_id   :integer
#  excuse       :string(255)
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#

class Penalty < ActiveRecord::Base
  belongs_to :to_user, :class_name => "User"
  belongs_to :from_user, :class_name => "User"
end
