require "spec_helper"

describe CalendarInvitationMailer do
  
  context "general" do

    before(:each) do
      ActionMailer::Base.deliveries = []
    end

    it 'should send calendar_invitation_email' do
      user = FactoryGirl.create(:user_with_two_friends_and_same_events)
      single_calendar_event = FactoryGirl.create(:calendar_event, :user=>user)
      work_sessions = [single_calendar_event.work_session]
      CalendarInvitationMailer.calendar_invitation_email(work_sessions,user,user.friends.first).deliver
      
      mail = ActionMailer::Base.deliveries.first
      mail.subject.should =~ /Einladung von #{user.name}/ 
      day_str = "#{I18n.localize(single_calendar_event.start_time.to_date,:format => "%A, %d. %b %Y")}"
      mail.body.should =~ /#{day_str}/ 
      hour_str = "#{I18n.localize(single_calendar_event.start_time.in_time_zone("Berlin"), :format =>"%H:%M" )}"
      mail.body.should =~ /#{hour_str}/ 
    end
    
 end

end
