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
  
  it "is creates a tokbox_session_id when asked if valid" do
    @work_session.tokbox_session_id.should be_nil    
    @work_session.should be_valid
    @work_session.tokbox_session_id.should_not be_nil     
  end
  
  

end
