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
#  referer                :string(255)
#  first_name             :string(255)
#  last_name              :string(255)
#  fb_ui                  :string(255)
#  registered             :boolean
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable 


  # Specifies a white list of model attributes that can be set via mass-assignment.
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me,  :referer, :fb_ui, :room, :registered

  validates :fb_ui, presence: true, uniqueness: true  
  validates :first_name, presence: true, length: { maximum: 30 }
  validates :last_name,  length: { maximum: 30 }

  
  # each user owns a video room. 
  # The room is created by the registrations_controller, when the user is created.
 # validates :room, presence: true#, uniqueness: true  
  
  has_many :connections,  :dependent => :destroy
  has_many :calendar_events, :dependent => :destroy
  
  has_one :room, :dependent => :destroy
  has_one :camera_audio, :dependent => :destroy 
  
  has_many :friendships, :dependent => :destroy
  has_many :friends, :through => :friendships, :dependent => :destroy
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id",  :dependent => :destroy
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user , :dependent => :destroy 
  
  has_many :sent_invitations, :class_name => 'Invitation', :foreign_key => 'sender_id', :dependent => :destroy
  
  after_initialize :init
  after_create :create_room #user must be first created with stored IP-address 

  def init
    self.registered ||= false
  end
    
  def name
    "#{first_name or ''} #{last_name or ''}"
  end
  
  def is_friend?(user)
     self.friends.map(&:id).include?(user.id)
   end
  
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
  
  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)    
    data = access_token.extra.raw_info
    user = nil
  #  if user = self.find_by_email(data.email)
  #    user
    puts "raw_info = #{data.to_yaml}"
    
    if user = User.find_by_fb_ui(data.id)
      user.update_attributes(
       :email => data.email,
       :first_name => data.first_name,
       :last_name => data.last_name)
       user
     else      
      # Create a user with a stub password. 
      user = self.create!(
             :email => data.email,
             :fb_ui => data.id,             
             :first_name => data.first_name,
             :last_name => data.last_name,
             :password => Devise.friendly_token[0,20]  
       )                    
    end
  #  user.update_fb_friends(access_token)
    user
  end
  
  def update_fb_friends(access_token)
    token = access_token.credentials.token
    facebook_user = FbGraph::User.new('me', :access_token => token).fetch()
    fb_friends = facebook_user.friends
    fb_friends.each do |fb_friend|
      friend = nil
      if friend = User.find_by_fb_ui(fb_friend.identifier)
        if !self.is_friend?(friend)
          Friendship.create_reciproke_friendship(self, friend)
          #optimize work session with this user
        end        
      else
         friend = create_fb_friend(fb_friend)
         Friendship.create_reciproke_friendship(self, friend)
      end
    end
    WorkSession.optimize_single_work_sessions(self)
  end
  
  # This method is only used for facebook friends
  def create_fb_friend(facebook_user)
    friend = User.create!(
           :email =>  "#{facebook_user.identifier}@startwork.in", 
           :fb_ui => facebook_user.identifier,
           :first_name => facebook_user.name,
           :referer => "FB-friend made to WorkBuddy by #{self.name}",
           :password => Devise.friendly_token[0,20],
     )           
  end
end
