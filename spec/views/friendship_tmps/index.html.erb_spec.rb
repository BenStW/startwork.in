require 'spec_helper'

describe "friendship_tmps/index" do
  before(:each) do
    assign(:friendship_tmps, [
      stub_model(FriendshipTmp,
        :user_id => 1,
        :friend_id => 1
      ),
      stub_model(FriendshipTmp,
        :user_id => 1,
        :friend_id => 1
      )
    ])
  end

  it "renders a list of friendship_tmps" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
