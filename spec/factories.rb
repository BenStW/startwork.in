# This will guess the User class
FactoryGirl.define do
  
  
  factory :user, :class=>User do
    sequence(:name) { |n| "foo#{n}" }
    sequence(:email) { |n| "foo#{n}@example.com" }
    password "foobar"
    password_confirmation { |u| u.password }
  #  room
    
    factory :user_with_two_friends_and_same_events do
      after_create do |user, evaluator|
        own_start_time = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day+1,10)
        own_calendar_event = 
          FactoryGirl.create(:calendar_event, :user => user, :start_time => own_start_time)
       
        friend1 = FactoryGirl.create(:user)
        friendship1 = FactoryGirl.create(:friendship, :user => user, :friend => friend1)
        friend1_start_time = own_start_time +1.hours
        friend1_calendar_event = 
          FactoryGirl.create(:calendar_event, :user => friend1, :start_time => friend1_start_time)

        friend2 = FactoryGirl.create(:user)
        friendship2 = FactoryGirl.create(:friendship, :user => user, :friend => friend2)
        friend2_start_time = own_start_time +1.hours
        friend2_calendar_event = 
          FactoryGirl.create(:calendar_event, :user => friend2, :start_time => friend2_start_time)

      end
    end
  end

  
  factory :calendar_event do
    start_time DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day+1,10)
    user
  end

  factory :friendship do
  end
  
  factory :work_session do
    start_time DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day+1,10)
    room
  end
  
 factory :room do
  # tokbox_session_id "factory_tokbox_session_id"
   user
 end

end