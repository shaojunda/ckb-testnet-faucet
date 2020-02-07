# frozen_string_literal: true

require "test_helper"

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  test "should get success when visit homepage" do
    get root_url

    assert_response :success
  end

  test "should render Welcome component" do
    get root_url

    assert_react_component "Welcome"
  end
end
