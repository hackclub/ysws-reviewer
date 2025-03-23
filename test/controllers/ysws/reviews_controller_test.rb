require "test_helper"

class Ysws::ReviewsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get ysws_reviews_new_url
    assert_response :success
  end
end
