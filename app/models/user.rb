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
#  comment                :string(255)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable 


  # Specifies a white list of model attributes that can be set via mass-assignment.
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me, :registered,  :referer, :fb_ui,  :comment

  validates :fb_ui, presence: true, uniqueness: true  
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name,  length: { maximum: 50 }

  
  # each user owns a video room. 
  # The room is created by the registrations_controller, when the user is created.
 # validates :room, presence: true#, uniqueness: true  
  
  has_many :user_hours

  has_one :camera_audio, :dependent => :destroy 
  
  has_many :friendships, :dependent => :destroy
  has_many :friends, :through => :friendships, :dependent => :destroy
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id",  :dependent => :destroy
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user , :dependent => :destroy 
  
  has_many :appointments, :dependent => :destroy
  has_many :received_appointments, :through => :recipient_appointments, :source => :appointment #, :conditions => ['recipient_appointments.user_id = ?',47]
  has_many :recipient_appointments, :dependent => :destroy
      
#  belongs_to :work_session, :foreign_key => 'guest_id'

  after_initialize :init  
  
 # attr_accessor :current_user
    
  def name
    "#{first_name or ''} #{last_name or ''}"
  end
  def init
    self.registered ||= false
  end
  def self.registered?
    where("registered = ?", true)
  end  
  
  def is_friend?(user)
     self.friends.map(&:id).include?(user.id)
  end
  
  def create_user_hour_now
   # c = DateTime.current
   # this_hour = DateTime.new(c.year,c.month,c.day, c.hour)
   # user_hour = self.user_hours.build(start_time: this_hour)
   # user_hour.find_or_build_work_session
   # user_hour.save
   # user_hour.group_hour.reload    #needed, as when an existing group_hour is found, it has not loaded the room 
   # user_hour  
  end  



  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)    
    data = access_token.extra.raw_info
    user = nil
    
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


    user.update_fb_friends(access_token)
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
      end
    end
  #  WorkSession.optimize_single_work_sessions(self)
  end
  
 # def accept_appointment(aapointment)
 #   if !self.received_appointments.include?(received_appointment)
 #     raise "can't accept appointment when it is not stored as received"
 #   end
 #   appointment = self.appointments.create(
 #      :start_time=>received_appointment.start_time, :end_time=>received_appointment.end_time)
 # end  
 #
   

end
