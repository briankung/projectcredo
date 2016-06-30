require 'test_helper'

class HomepageControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get root_url
    assert_response :success
  end

  test 'should get index as json' do
    get root_url, params: { format: 'json' }
    assert_response :success
  end
end
