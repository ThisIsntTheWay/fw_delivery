require "test_helper"

class FirmwaresControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get firmwares_index_url
    assert_response :success
  end

  test "should get new" do
    get firmwares_new_url
    assert_response :success
  end

  test "should get create" do
    get firmwares_create_url
    assert_response :success
  end

  test "should get destroy" do
    get firmwares_destroy_url
    assert_response :success
  end
end
