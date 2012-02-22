require 'test_helper'

class PenaltiesControllerTest < ActionController::TestCase
  test "should get add" do
    get :add
    assert_response :success
  end

  test "should get latest" do
    get :latest
    assert_response :success
  end

end
