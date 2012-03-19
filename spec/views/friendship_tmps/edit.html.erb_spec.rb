require 'spec_helper'

describe "friendship_tmps/edit" do
  before(:each) do
    @friendship_tmp = assign(:friendship_tmp, stub_model(FriendshipTmp,
      :user_id => 1,
      :friend_id => 1
    ))
  end

  it "renders the edit friendship_tmp form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => friendship_tmps_path(@friendship_tmp), :method => "post" do
      assert_select "input#friendship_tmp_user_id", :name => "friendship_tmp[user_id]"
      assert_select "input#friendship_tmp_friend_id", :name => "friendship_tmp[friend_id]"
    end
  end
end
