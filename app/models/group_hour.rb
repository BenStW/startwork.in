# == Schema Information
#
# Table name: group_hours
#
#  id                :integer         not null, primary key
#  start_time        :datetime
#  tokbox_session_id :string(255)
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#

class GroupHour < ActiveRecord::Base
   validates :start_time, :tokbox_session_id, :presence => true
   validate :users_cant_be_more_then_five
   has_many :user_hours
   has_many :users, :through=> :user_hours
   
   before_destroy :has_no_user_hours?
   # don't fill tokbox_session_id with before_create because the IP of current_user needs to be overgiven
   
   
   def users_cant_be_more_then_five
     if users.count>5
       errors.add(:users, "Users can't be more then 5 for GroupHour (#{id})")
     end
   end   
   
    
   def has_no_user_hours?
      self.user_hours.count == 0
   end   
end
