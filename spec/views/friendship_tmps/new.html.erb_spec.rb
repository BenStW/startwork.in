require 'spec_helper'

describe "friendship_tmps/new" do
  before(:each) do
    assign(:friendship_tmp, stub_model(FriendshipTmp,
      :user_id => 1,
      :friend_id => 1
    ).as_new_record)
  end

  it "renders new friendship_tmp form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => friendship_tmps_path, :method => "post" do
      assert_select "input#friendship_tmp_user_id", :name => "friendship_tmp[user_id]"
      assert_select "input#friendship_tmp_friend_id", :name => "friendship_tmp[friend_id]"
    end
  end
end
