# This will guess the User class
FactoryGirl.define do
  
  
  factory :user, :class=>User do
    sequence(:name) { |n| "foo#{n}" }
    sequence(:email) { |n| "foo#{n}@example.com" }
    password "foobar"
    password_confirmation { |u| u.password }
    
    factory :user_with_work_session_time do
      after_create do |user, evaluator|
        FactoryGirl.create(:work_session_time, :user => user)
      end
    end
    
    factory :user_with_two_friends_and_overlapping_times do
      after_create do |user, evaluator|
        own_start_time = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day+1,10)
        own_end_time = DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day+1,13)                
        own_work_session_time = 
          FactoryGirl.create(:work_session_time, :user => user, :start_time => own_start_time, :end_time => own_end_time)
       
        friend1 = FactoryGirl.create(:user)
        friendship1 = FactoryGirl.create(:friendship, :user => user, :friend => friend1)
        friend1_start_time = own_start_time +1.hours
        friend1_end_time = own_end_time + 3.hours               
        friend1_work_session_time = 
          FactoryGirl.create(:work_session_time, :user => friend1, :start_time => friend1_start_time, :end_time => friend1_end_time)

        friend2 = FactoryGirl.create(:user)
        friendship2 = FactoryGirl.create(:friendship, :user => user, :friend => friend2)
        friend2_start_time = own_start_time +2.hours
        friend2_end_time = own_end_time + 4.hours               
        friend2_work_session_time = 
          FactoryGirl.create(:work_session_time, :user => friend2, :start_time => friend2_start_time, :end_time => friend2_end_time)


      end
    end
  end
  
  factory :work_session_time do
    start_time DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day+1,10)
    end_time DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day+1,13)
  end

  factory :friendship do
  end

end