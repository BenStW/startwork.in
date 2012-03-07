# == Schema Information
#
# Table name: work_sessions
#
#  id                :integer         not null, primary key
#  tokbox_session_id :string(255)
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#

require 'spec_helper'

describe WorkSession do
  before(:each) do
    @work_session = WorkSession.new
  end
  
  it "is not valid without tokbox_session" do
    @work_session.should_not be_valid
  end
  
  it "is valid with a tokbox_session" do
    @work_session.generate_tokbox_session
    @work_session.should be_valid
  end
  
  it "creates a tokbox_token" do
    @work_session.generate_tokbox_session
    connection_data = {:user_id =>1, :user_name => "Ben"}
    tokbox_token = @work_session.generate_tokbox_token(connection_data)
    tokbox_token.should_not be_nil
  end
  
end
