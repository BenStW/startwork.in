Given /^the following users with work session times$/ do |table|
  c = DateTime.current
  tomorrow = DateTime.new(c.year,c.month,c.day+1,0)
  table.hashes.each do |hash|
    name = hash[:name]
    start_time_hour = hash[:start_time].to_i
    start_time = tomorrow + start_time_hour.hours
    end_time_hour = hash[:end_time].to_i
    end_time = tomorrow + end_time_hour.hours  
    if start_time >= end_time 
       raise "Times wrongly defined: #{start_time} >= #{end_time}"  
    end
   if !user = User.find_by_name(name)      
     user = FactoryGirl.create(:user, :name => hash[:name])
   end
   ws = FactoryGirl.create(:work_session_time, :user=>user, :start_time=>start_time, :end_time=>end_time)
  end
end


Given /^the following friendships$/ do |table|
  table.hashes.each do |hash|
    user1 = User.find_by_name(hash[:user1])
    user2 = User.find_by_name(hash[:user2])
    f1 = FactoryGirl.create(:friendship, :user=>user1, :friend=>user2)
    f2 = FactoryGirl.create(:friendship, :user=>user2, :friend=>user1)    
  end
end
