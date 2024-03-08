require "test_helper"

class BangoHudaControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get bango_huda_index_url
    assert_response :success
  end
end
