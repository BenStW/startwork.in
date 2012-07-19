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
  end



  factory :friendship do
    user
    association :friend, factory: :user
  end


  
  factory :camera_audio do
    user
  end
  
  
  factory :appointment do
    user
    start_time DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,10)+1.day
    end_time DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,12)+1.day
  end
  
  factory :recipient_appointment do
    user
    appointment
  end  
  
  factory :group_hour do
    tokbox_session_id "factory_tokbox_session_id"
    start_time DateTime.new(DateTime.current.year, DateTime.current.month,DateTime.current.day,10)+1.day
  end  

end