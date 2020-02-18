# frozen_string_literal: true

require "test_helper"

class SendCapacityServiceTest < ActiveSupport::TestCase
  test "should fill tx_hash and tx_status to first pending event" do
    create_list(:claim_event, 2)
    create_list(:claim_event, 2, status: "processed")
    first_pending_event = ClaimEvent.order(:id).pending.first
    tx_hash = "0x1deb37a41c037919d8b0bbce6e7ac19fb00b7e12f0cacff369acd416369e72d9"
    ckb_wallet = mock
    ckb_wallet.expects(:send_capacity).with(first_pending_event.address_hash, ClaimEvent::DEFAULT_CLAIM_CAPACITY, fee: ClaimEvent::DEFAULT_TRANSACTION_FEE, outputs_validator: "passthrough").returns(tx_hash)

    assert_changes -> { first_pending_event.reload.tx_hash }, from: nil, to: tx_hash do
      SendCapacityService.new(ckb_wallet).call
    end
  end

  test "all pending events except first pending event are not changed" do
    create_list(:claim_event, 2)
    create_list(:claim_event, 2, status: "processed")
    first_pending_event = ClaimEvent.order(:id).pending.first
    tx_hash = "0x1deb37a41c037919d8b0bbce6e7ac19fb00b7e12f0cacff369acd416369e72d9"
    ckb_wallet = mock
    ckb_wallet.expects(:send_capacity).with(first_pending_event.address_hash, ClaimEvent::DEFAULT_CLAIM_CAPACITY, fee: ClaimEvent::DEFAULT_TRANSACTION_FEE, outputs_validator: "passthrough").returns(tx_hash)

    SendCapacityService.new(ckb_wallet).call

    assert_equal ["pending"], ClaimEvent.where("id != ?", first_pending_event.id).pending.pluck(:status).uniq
    assert_nil ClaimEvent.order(:id).pending.last.tx_hash
  end

  test "should change first pending event which has tx_hash status to processed when tx is present and tx_status is committed" do
    create_list(:claim_event, 2)
    create_list(:claim_event, 2, status: "processed")
    first_pending_event = ClaimEvent.order(:id).pending.first
    tx_hash = "0x1deb37a41c037919d8b0bbce6e7ac19fb00b7e12f0cacff369acd416369e72d9"
    first_pending_event.update(tx_hash: tx_hash)
    ckb_wallet = mock
    ckb_wallet.expects(:get_transaction).with(tx_hash).returns(OpenStruct.new(tx_status: OpenStruct.new(status: "committed"), transaction: {}))

    assert_changes -> { first_pending_event.reload.status }, from: "pending", to: "processed" do
      SendCapacityService.new(ckb_wallet).call
    end
  end

  test "should change first pending event tx_status to committed which has tx_hash when tx is present and tx_status is committed" do
    create_list(:claim_event, 2)
    create_list(:claim_event, 2, status: "processed")
    first_pending_event = ClaimEvent.order(:id).pending.first
    tx_hash = "0x1deb37a41c037919d8b0bbce6e7ac19fb00b7e12f0cacff369acd416369e72d9"
    first_pending_event.update(tx_hash: tx_hash)
    ckb_wallet = mock
    ckb_wallet.expects(:get_transaction).with(tx_hash).returns(OpenStruct.new(tx_status: OpenStruct.new(status: "committed"), transaction: {}))

    assert_changes -> { first_pending_event.reload.tx_status }, from: "pending", to: "committed" do
      SendCapacityService.new(ckb_wallet).call
    end
  end

  test "should change first pending event tx_status to proposed which has tx_hash when tx is present and tx_status is proposed" do
    create_list(:claim_event, 2)
    create_list(:claim_event, 2, status: "processed")
    first_pending_event = ClaimEvent.order(:id).pending.first
    tx_hash = "0x1deb37a41c037919d8b0bbce6e7ac19fb00b7e12f0cacff369acd416369e72d9"
    first_pending_event.update(tx_hash: tx_hash)
    ckb_wallet = mock
    ckb_wallet.expects(:get_transaction).with(tx_hash).returns(OpenStruct.new(tx_status: OpenStruct.new(status: "proposed"), transaction: {}))

    assert_changes -> { first_pending_event.reload.tx_status }, from: "pending", to: "proposed" do
      SendCapacityService.new(ckb_wallet).call
    end
  end

  test "should update first pending event's tx_hash which has tx_hash when tx is not exist" do
    create_list(:claim_event, 2)
    create_list(:claim_event, 2, status: "processed")
    first_pending_event = ClaimEvent.order(:id).pending.first
    tx_hash = "0x1deb37a41c037919d8b0bbce6e7ac19fb00b7e12f0cacff369acd416369e72d9"
    new_tx_hash = "0x7e408350b9e5deaa4496766ec038f9c9f362859e48f7410d1b8f5a61063db9e3"
    first_pending_event.update(tx_hash: tx_hash)
    ckb_wallet = mock
    ckb_wallet.expects(:get_transaction).with(tx_hash).returns(nil)
    ckb_wallet.expects(:send_capacity).with(first_pending_event.address_hash, ClaimEvent::DEFAULT_CLAIM_CAPACITY, fee: ClaimEvent::DEFAULT_TRANSACTION_FEE, outputs_validator: "passthrough").returns(new_tx_hash)

    assert_changes -> { first_pending_event.reload.tx_hash }, from: tx_hash, to: new_tx_hash do
      SendCapacityService.new(ckb_wallet).call
    end
  end

  test "should update official account balance when claim event committed" do
    create_list(:claim_event, 2)
    create_list(:claim_event, 2, status: "processed")
    create(:account)
    first_pending_event = ClaimEvent.order(:id).pending.first
    tx_hash = "0x1deb37a41c037919d8b0bbce6e7ac19fb00b7e12f0cacff369acd416369e72d9"
    first_pending_event.update(tx_hash: tx_hash)
    ckb_wallet = mock
    ckb_wallet.expects(:get_transaction).with(tx_hash).returns(OpenStruct.new(tx_status: OpenStruct.new(status: "committed"), transaction: {}))

    assert_difference -> { Account.official_account.balance }, -first_pending_event.capacity do
      SendCapacityService.new(ckb_wallet).call
    end
  end
end
