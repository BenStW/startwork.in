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
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Specifies a white list of model attributes that can be set via mass-assignment.
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me,  :referer

  validates :email, presence: true, uniqueness: true  
  validates :first_name, :last_name, presence: true, length: { maximum: 30 }#, uniqueness: true
  
  # each user owns a video room. 
  # The room is created by the registrations_controller, when the user is created.
  #validates :room, presence: true
  
  has_many :connections
  has_many :calendar_events, :dependent => :destroy
  
  has_one :room
  has_one :camera_audio  
  
  has_many :friendships
  has_many :friends, :through => :friendships
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user  
  
  has_many :sent_invitations, :class_name => 'Invitation', :foreign_key => 'sender_id'
  
  def name
    "#{first_name or ''} #{last_name or ''}"
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
  
  

end
