# This will guess the User class
FactoryGirl.define do
  
  
  factory :user, :class=>User do
    sequence(:first_name) { |n| "first_foo#{n}" }
    sequence(:last_name) { |n| "last_foo#{n}" }    
    sequence(:email) { |n| "foo#{n}@example.com" }
    password "secret"
    password_confirmation { |u| u.password }
    sequence(:fb_ui) { |n| n.to_s} 
    current_sign_in_ip "0.0.0.0"
    registered true
    
    after_create do |user|
      user.room.tokbox_session_id = "tokbox_session_id"
      user.room.save
    end

  #  after_build do |user|
  #    TokboxApi.stub_chain(:instance, :generate_session).and_return("tokbox_session_id")  
  #  end
    
    factory :user_with_two_friends_and_same_events do
      after_create do |user, evaluator|
        own_start_time = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,10)+1.day
        own_calendar_event = 
          FactoryGirl.create(:calendar_event, :user => user, :start_time => own_start_time)
        own_work_session = own_calendar_event.work_session
       
        friend1 = FactoryGirl.create(:user)
        friendship1 = FactoryGirl.create(:friendship, :user => user, :friend => friend1)
        inv_friendship1 = FactoryGirl.create(:friendship, :user => friend1, :friend => user)        
        friend1_start_time = own_start_time
        friend1_calendar_event = 
          FactoryGirl.create(:calendar_event, :user => friend1, :start_time => friend1_start_time, :work_session => own_work_session)

        friend2 = FactoryGirl.create(:user)
        friendship2 = FactoryGirl.create(:friendship, :user => user, :friend => friend2)
        inv_friendship2 = FactoryGirl.create(:friendship, :user => friend2, :friend => user)                
        friend2_start_time = own_start_time
        friend2_calendar_event = 
          FactoryGirl.create(:calendar_event, :user => friend2, :start_time => friend2_start_time, :work_session => own_work_session)

      end
    end
  end

  
  factory :calendar_event do
    user
    start_time DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,10)+1.day
    work_session { |ce| FactoryGirl.create(:work_session, :start_time => ce.start_time, :room => ce.user.room )}
  end

  factory :friendship do
    user
    association :friend, factory: :user
  end
  
  factory :work_session do
    start_time DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,10)+1.day
    room 
  end
  

  
  factory :room do  
    user
    tokbox_session_id = "tokbox_session_id"
#    after_build do |user|
#      TokboxApi.stub_chain(:instance, :generate_session).and_return("tokbox_session_id")  
#    end
  end
  
  factory :invitation do
    association :sender, factory: :user
    recipient_mail "recipient@mail.com"
  end
  
  factory :camera_audio do
    user
  end
  
  
  factory :appointment do
    association :sender, factory: :user
    start_time DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,10)+1.day
    end_time DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,12)+1.day
  end
  
  
  factory :calendar_invitation do
    association :sender, factory: :user
  end
  
  factory :calendar_invitation_mailer do 
  end

end