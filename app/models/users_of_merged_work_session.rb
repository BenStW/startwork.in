class UsersOfMergedWorkSession < Tableless
  belongs_to :merged_work_session
  belongs_to :user
  
  attr_accessible :user_id
  
  column :merged_work_session_id, :integer
  column :user_id, :integer
end
