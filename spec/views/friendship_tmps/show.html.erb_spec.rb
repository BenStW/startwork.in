require 'spec_helper'

describe "friendship_tmps/show" do
  before(:each) do
    @friendship_tmp = assign(:friendship_tmp, stub_model(FriendshipTmp,
      :user_id => 1,
      :friend_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
