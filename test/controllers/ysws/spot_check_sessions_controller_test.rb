require "test_helper"

class Ysws::SpotCheckSessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get ysws_spot_check_sessions_new_url
    assert_response :success
  end

  test "should get create" do
    get ysws_spot_check_sessions_create_url
    assert_response :success
  end

  test "should get show" do
    get ysws_spot_check_sessions_show_url
    assert_response :success
  end
end
