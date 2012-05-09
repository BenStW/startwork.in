Given /^the following users with calendar events$/ do |table|
  c = DateTime.current
  tomorrow = DateTime.new(c.year,c.month,c.day)+1.day
  table.hashes.each do |hash|
    start_time = tomorrow + hash[:start_time].to_i.hours
    end_time = tomorrow + hash[:end_time].to_i.hours  
    user = FactoryGirl.create(:user, :first_name => hash[:name]) unless user = User.find_by_first_name(hash[:name])  
    sign_in user
    visit calendar_new_event_path(:start_time=>start_time, :end_time=>end_time)
    log_out   
  end
end


Given /^the following friendships$/ do |table|
  table.hashes.each do |hash|
    user1 = FactoryGirl.create(:user, :first_name => hash[:user1]) unless user1 = User.find_by_first_name(hash[:user1])  
    user2 = FactoryGirl.create(:user, :first_name => hash[:user2]) unless user2 = User.find_by_first_name(hash[:user2]) 
    sign_in user1 
    visit friendships_url
    find('#'+user2.first_name).click_link("Add as work-buddy")
    log_out   
  end
end

When /^the following friendships are removed$/ do |table|
  table.hashes.each do |hash|
    user1 = User.find_by_first_name(hash[:user1])  
    user2 = User.find_by_first_name(hash[:user2])
    sign_in user1 
    visit friendships_url
    find('#'+user2.first_name).click_link("Remove as work-buddy")
    log_out
  end
end

Then /^the following work_sessions$/ do |table|
  c = DateTime.current
  tomorrow = DateTime.new(c.year,c.month,c.day)+1.day 
  table.hashes.each do |hash|
    start_time = tomorrow + hash[:start_time].to_i.hours
    users_array = hash[:users].split( /, */ ).map { |first_name| User.find_by_first_name(first_name) }
    first_user = users_array[0]
    first_user.should_not be(nil), "No User found!"
    calendar_event = first_user.calendar_events.where(:start_time=>start_time)
    message = "Found #{calendar_event.count} calendar_events for user #{first_user.first_name} and start_time #{start_time.hour}"
    calendar_event.count.should eq(1), message
    calendar_event = calendar_event[0]
    work_session = calendar_event.work_session
    message = "Expected users #{users_array.sort.map(&:first_name)} for #{start_time.hour}, but found #{work_session.users.sort.map(&:first_name)}"
    work_session.users.sort.should eq(users_array.sort), message 
  end
  message = "Expected #{table.hashes.count} work_sessions, but found #{WorkSession.all.count}"
 # msg = WorkSession.all.map{|ws| "|#{ws.start_time.hour} |  #{ws.users.map(&:first_name)}"}
  table.hashes.count.should eq(WorkSession.all.count), message
end
