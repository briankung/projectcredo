require 'test_helper'

class ListsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @list = List.create name: 'hey'
  end

  test "should get index" do
    get root_url
    assert_response :success
  end

  # test "should destroy list" do
  #   assert_difference('List.count', -1) do
  #     delete list_url(@list)
  #   end

  #   assert_redirected_to lists_path
  # end
end
