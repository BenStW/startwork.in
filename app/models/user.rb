# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(255)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  name                   :string(255)
#  activated              :boolean
#  referer                :string(255)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :activated, :referer
  
  validates :name, presence: true, length: { maximum: 20 }, uniqueness: true
  #validates :room, presence: true
  
  has_many :penalties, :foreign_key => "to_user_id"
  has_many :connections
 # has_many :work_session_times, :dependent => :destroy
  has_many :calendar_events, :dependent => :destroy
  
  has_one :room
  
  has_many :friendships
  has_many :friends, :through => :friendships
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user  
  
  has_many :sent_invitations, :class_name => 'Invitation', :foreign_key => 'sender_id'
  
  scope :not_activated, where(:activated => false)
  
  before_create :not_activate
  
  def start_connection
    if !open_connections?      
      connection = connections.build(start_time: DateTime.current)
      connection.save
      logger.info "start connection with id #{connection.id} for user_id #{id}"
      connection
    end
  end
  
  def open_connections?
    connections.find_all_by_end_time(nil).count>0
  end
  
  def end_connection
    open_connections = connections.find_all_by_end_time(nil)
    for connection in open_connections
      connection.end_time = DateTime.current
      connection.save
      logger.info "Closed connection #{connection.id} of user_id #{id}"
   end
  end
  
  def duration_of_connections
    duration=0
    for connection in connections
      duration+=connection.duration
    end
    duration
  end
  
  def activated?
    activated
  end
  
  def save_referer(referer)
    self.referer = referer
    self.save
  end
  
  def all_events_of_this_week
    self.calendar_events.this_week
  end
  
  
  def all_friends_events_of_this_week
    friend_ids = self.friendships.map(&:friend).map(&:id)
   events = CalendarEvent.this_week.has_user_ids(friend_ids)
    if events.empty?
        return []
    end
    return_events = [events[0]]
    events.each do |next_event|
      last_event = return_events.last
      if next_event.start_time==last_event.start_time
        next
      elsif next_event.start_time < last_event.start_time
        raise "#{event.start_time} is lower then #{last_event.start_time}"
      else
        return_events << next_event
      end
    end
    return_events 
    
  end
  
  
  private
  
  def not_activate
   self.activated = false
   true
  end
  
  def activate
    self.activated = true
  end  
  


   
  
=begin 
  def open_penalties?
    open_penalties = penalties.find_all_by_end_time(nil)
    open_penalties = close_old_open_penalties(open_penalties)
    open_penalties.length>0 
  end
  
  private
   
  def close_old_open_penalties(open_penalties)
    for penalty in open_penalties
      if !penalty.current_work_hour?
        penalty.close
        penalty.save
        open_penalties.delete(penalty)
      end
    end
    open_penalties
  end  
=end 
end
