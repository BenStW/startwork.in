# == Schema Information
#
# Table name: groups
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  session_id  :string(255)
#


class Group < ActiveRecord::Base
  validates :name, :description, :presence => true
  validates :name, :uniqueness => true
end
