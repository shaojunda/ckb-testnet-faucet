# frozen_string_literal: true

require "test_helper"

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  test "should get success when visit homepage" do
    get root_url

    assert_response :success
  end

  test "should render Welcome component" do
    account = Account.official_account
    official_account = { addressHash: account.address_hash, balance: account.ckb_balance.to_s }
    aggron_explorer_host = Rails.application.credentials.AGGRON_EXPLORER_HOST

    get root_url

    assert_react_component "Welcome" do |props|
      assert_empty props[:claimEvents][:data]
      assert_equal official_account, props[:officialAccount]
      assert_equal aggron_explorer_host, props[:aggronExplorerHost]
    end
  end
end
