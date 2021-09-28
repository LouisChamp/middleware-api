require "test_helper"

class MockControllerTest < ActionDispatch::IntegrationTest
  test "should get profile" do
    get mock_profile_url
    assert_response :success
  end

  test "should get read_post" do
    get mock_read_post_url
    assert_response :success
  end

  test "should get add_comment" do
    get mock_add_comment_url
    assert_response :success
  end
end
