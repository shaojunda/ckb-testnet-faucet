# frozen_string_literal: true

require "test_helper"

class ClaimEventsControllerTest < ActionDispatch::IntegrationTest
  test "should create new claim event when address hash is valid" do
    address_hash = "ckt1qyqd5eyygtdmwdr7ge736zw6z0ju6wsw7rssu8fcve"
    assert_difference -> { ClaimEvent.count }, 1 do
      post claim_events_url, params: { claim_event: { address_hash: address_hash } }
    end
  end
end
