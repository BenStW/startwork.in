require 'spec_helper'

describe "invitations/edit" do
  before(:each) do
    @invitation = assign(:invitation, stub_model(Invitation,
      :sender_id => 1,
      :recipient_mail => "MyString"
    ))
  end

  it "renders the edit invitation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => invitations_path(@invitation), :method => "post" do
      assert_select "input#invitation_sender_id", :name => "invitation[sender_id]"
      assert_select "input#invitation_recipient_mail", :name => "invitation[recipient_mail]"
    end
  end
end
