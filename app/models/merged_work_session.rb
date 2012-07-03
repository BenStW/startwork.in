class MergedWorkSession < Tableless

  
  column :start_time, :datetime
  column :end_time, :datetime
#  column :friends
  has_many :friends, :through => :users_of_merged_work_sessions, :source => :user
  has_many :users_of_merged_work_sessions

      
  def self.merge_continuing_work_sessions(work_sessions,  own_user = nil, equal_friends_boolean = false)
    if work_sessions.length==0
      []
    else
       work_sessions.sort! { |a,b| a.start_time <=> b.start_time }
       merge_continuing_sorted_work_sessions(work_sessions,own_user,equal_friends_boolean)
    end
  end  
   
  def add_friends(own_user, users)
     users.each do |user|
       if own_user.is_friend?(user) and !self.friends.map(&:id).include?(user.id)
         self.friends << user
       end  
    end
  end
  
  private 
  
  def self.merge_continuing_sorted_work_sessions(work_sessions,  own_user = nil, equal_friends_boolean = false)
    merged_work_sessions_array = Array.new
    before_work_session = work_sessions.shift
    merged_work_sessions = MergedWorkSession.new(:start_time=>before_work_session.start_time)
    merged_work_sessions.add_friends(own_user, before_work_session.users)
    
    work_sessions.each do |work_session|
      if (before_work_session.start_time == work_session.start_time or 
         before_work_session.start_time + 1.hour == work_session.start_time) and 
           (!equal_friends_boolean or 
           (equal_friends_boolean and before_work_session.equal_friends(work_session,own_user) ))
      then
        # keep merging
      else
        merged_work_sessions.end_time = before_work_session.start_time+1.hour
        merged_work_sessions_array.push(merged_work_sessions)
        merged_work_sessions = MergedWorkSession.new(:start_time=>work_session.start_time)         
      end
      before_work_session = work_session
      merged_work_sessions.add_friends(own_user, before_work_session.users)
    end
     
    merged_work_sessions.end_time = before_work_session.start_time+1.hour
    merged_work_sessions_array.push(merged_work_sessions)
    
    merged_work_sessions_array
    
  end
  

end
