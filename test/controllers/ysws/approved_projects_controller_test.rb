require "test_helper"

class Ysws::ApprovedProjectsControllerTest < ActionDispatch::IntegrationTest
  test "should get random" do
    get ysws_approved_projects_random_url
    assert_response :success
  end
end
