# frozen_string_literal: true

require "test_helper"

class ClaimEventValidatorTest < ActiveSupport::TestCase
  test "should create new claim event when address hash is valid and passed all validations" do
    assert_difference -> { ClaimEvent.count }, 1 do
      create(:claim_event)
    end
  end

  test "should reject claim when claim interval is less than 3 hours" do
    address_hash = "ckt1qyqd5eyygtdmwdr7ge736zw6z0ju6wsw7rssu8fcve"
    create(:claim_event, address_hash: address_hash)
    claim_event = ClaimEvent.where(address_hash: address_hash).where("created_at_unixtimestamp > ?", 3.hours.ago.to_i).pending.order(:id).first
    next_valid_time = Time.at(claim_event.created_at_unixtimestamp + 3.hours)
    claim_event = build(:claim_event, address_hash: address_hash)

    assert_not claim_event.save
    assert_equal "Claim interval must be greater than 3 hours. Next valid time is #{next_valid_time}.", claim_event.errors[:address_hash].first
  end

  test "should reject claim when one IP claim count exceeds the maximum" do
    create_list(:claim_event, 8, ip_addr: "127.0.0.1")
    address_hash = "ckt1qyqd5eyygtdmwdr7ge736zw6z0ju6wsw7rssu8fcve"
    claim_event = build(:claim_event, address_hash: address_hash, ip_addr: "127.0.0.1")

    assert_not claim_event.save
    assert_equal "Get up to 8 times claim per IP per day.", claim_event.errors[:address_hash].first
  end

  test "should reject claim when address hash is invalid" do
    address_hash = "123"
    claim_event = build(:claim_event, address_hash: address_hash)

    assert_not claim_event.save
    assert_equal "Address is invalid.", claim_event.errors[:address_hash].first
  end

  test "should reject claim when address is not short payload format" do
    address_hash = "ckt1qyqlqn8vsj7r0a5rvya76tey9jd2rdnca8lqh4kcuq"
    claim_event = build(:claim_event, address_hash: address_hash)

    assert_not claim_event.save
    assert_equal "Address cannot be multisig short payload format.", claim_event.errors[:address_hash].first
  end

  test "should reject claim when address is not testnet address" do
    address_hash = "ckb1qyqq5jr0hrm0uc8hduqp6cmjmfqmayghyfvspnxmu4"
    claim_event = build(:claim_event, address_hash: address_hash)

    assert_not claim_event.save
    assert_equal "Address must be a testnet address.", claim_event.errors[:address_hash].first
  end

  test "should reject claim when payment amount exceeds daily limit" do
    create(:claim_event, capacity: 4_000_000 * 10**8)
    address_hash = "ckt1qyqd5eyygtdmwdr7ge736zw6z0ju6wsw7rssu8fcve"
    claim_event = build(:claim_event, address_hash: address_hash)

    assert_not claim_event.save
    assert_equal "Faucet payment amount exceeds the daily limit.", claim_event.errors[:address_hash].first
  end

  test "should reject claim when target address hash is official address" do
    account = create(:account)
    claim_event = build(:claim_event, address_hash: account.address_hash)

    assert_not claim_event.save
    assert_equal "Does not support transfers to official address.", claim_event.errors[:address_hash].first
  end
end
