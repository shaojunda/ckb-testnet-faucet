# frozen_string_literal: true

require "test_helper"

class ClaimEventsControllerTest < ActionDispatch::IntegrationTest
  test "should create new claim event when address hash is valid" do
    address_hash = "ckt1qyqd5eyygtdmwdr7ge736zw6z0ju6wsw7rssu8fcve"
    assert_difference -> { ClaimEvent.count }, 1 do
      post claim_events_url, params: { claim_event: { address_hash: address_hash } }
    end
  end

  test "should reject claim when claim interval is less than 3 hours" do
    address_hash = "ckt1qyqd5eyygtdmwdr7ge736zw6z0ju6wsw7rssu8fcve"
    create(:claim_event, address_hash: address_hash)
    claim_event = ClaimEvent.where(address_hash: address_hash).where("created_at_unixtimestamp > ?", 3.hours.ago.to_i).pending.order(:id).first
    next_valid_time = Time.at(claim_event.created_at_unixtimestamp + 3.hours)

    post claim_events_url, params: { claim_event: { address_hash: address_hash } }

    assert_response 422
    assert_equal "Claim interval must be greater than 3hours. Next valid time is #{next_valid_time}.", json["address_hash"].first
  end

  test "should reject claim when one IP claim count exceeds the maximum" do
    create_list(:claim_event, 8, ip_addr: "127.0.0.1")
    address_hash = "ckt1qyqd5eyygtdmwdr7ge736zw6z0ju6wsw7rssu8fcve"

    post claim_events_url, params: { claim_event: { address_hash: address_hash } }

    assert_response 422
    assert_equal "Get up to 8 times claim per IP per day.", json["address_hash"].first
  end

  test "should reject claim when address hash is invalid" do
    address_hash = "123"

    post claim_events_url, params: { claim_event: { address_hash: address_hash } }

    assert_response 422
    assert_equal "Address is invalid.", json["address_hash"].first
  end

  test "should reject claim when address is not short payload format" do
    address_hash = "ckt1q3w9q60tppt7l3j7r09qcp7lxnp3vcanvgha8pmvsa3jplykxn32s08dj83qavwc4l4ceyeta2ryhkahxrndxacqqqqqqqgqyqx3vx8k"

    post claim_events_url, params: { claim_event: { address_hash: address_hash } }

    assert_response 422
    assert_equal "Address must be a blake160 short payload format.", json["address_hash"].first
  end

  test "should reject claim when address is not testnet address" do
    address_hash = "ckb1qyqq5jr0hrm0uc8hduqp6cmjmfqmayghyfvspnxmu4"

    post claim_events_url, params: { claim_event: { address_hash: address_hash } }

    assert_response 422
    assert_equal "Address must be a testnet address.", json["address_hash"].first
  end

  test "should reject claim when payment amount exceeds daily limit" do
    create(:claim_event, capacity: 4_000_000)
    address_hash = "ckt1qyqd5eyygtdmwdr7ge736zw6z0ju6wsw7rssu8fcve"

    post claim_events_url, params: { claim_event: { address_hash: address_hash } }

    assert_response 422
    assert_equal "Faucet payment amount exceeds the daily limit.", json["address_hash"].first
  end

  test "should reject claim when target address hash is official address" do
    account = create(:account)

    post claim_events_url, params: { claim_event: { address_hash: account.address_hash } }

    assert_response 422
    assert_equal "Does not support transfers to official address.", json["address_hash"].first
  end
end
