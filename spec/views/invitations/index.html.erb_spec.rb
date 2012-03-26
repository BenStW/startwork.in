require 'spec_helper'

describe "invitations/index" do
  before(:each) do
    assign(:invitations, [
      stub_model(Invitation,
        :sender_id => 1,
        :recipient_mail => "Recipient Mail"
      ),
      stub_model(Invitation,
        :sender_id => 1,
        :recipient_mail => "Recipient Mail"
      )
    ])
  end

  it "renders a list of invitations" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Recipient Mail".to_s, :count => 2
  end
end
