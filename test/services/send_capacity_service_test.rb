# frozen_string_literal: true

require "test_helper"

class SendCapacityServiceTest < ActiveSupport::TestCase
  test "should fill tx_hash and tx_status to first pending event" do
    create_list(:claim_event, 2)
    create_list(:claim_event, 2, status: "processed")
    first_pending_event = ClaimEvent.order(:id).pending.first
    tx_hash = "0x1deb37a41c037919d8b0bbce6e7ac19fb00b7e12f0cacff369acd416369e72d9"
    ckb_wallet = mock
    tx = build_tx(tx_hash)
    min_fee = tx.fee(1000) + 100
    ckb_wallet.expects(:generate_tx).with(first_pending_event.address_hash, first_pending_event.capacity).returns(tx)
    ckb_wallet.expects(:send_capacity).with(first_pending_event.address_hash, ClaimEvent::DEFAULT_CLAIM_CAPACITY, fee: min_fee, outputs_validator: "passthrough").returns(tx_hash)

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
    tx = build_tx(tx_hash)
    min_fee = tx.fee(1000) + 100
    ckb_wallet.expects(:generate_tx).with(first_pending_event.address_hash, first_pending_event.capacity).returns(tx)
    ckb_wallet.expects(:send_capacity).with(first_pending_event.address_hash, ClaimEvent::DEFAULT_CLAIM_CAPACITY, fee: min_fee, outputs_validator: "passthrough").returns(tx_hash)

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
    tx = build_tx(new_tx_hash)
    min_fee = tx.fee(1000) + 100
    ckb_wallet.expects(:generate_tx).with(first_pending_event.address_hash, first_pending_event.capacity).returns(tx)
    ckb_wallet.expects(:send_capacity).with(first_pending_event.address_hash, ClaimEvent::DEFAULT_CLAIM_CAPACITY, fee: min_fee, outputs_validator: "passthrough").returns(new_tx_hash)

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

  private
    def build_tx(new_tx_hash)
      out_point = CKB::Types::OutPoint.new(index: 0, tx_hash: "0xace5ea83c478bb866edf122ff862085789158f5cbff155b7bb5f13058555b708")
      cell_deps = CKB::Types::CellDep.new(dep_type: "dep_group", out_point: out_point)
      input = CKB::Types::Input.new(previous_output: CKB::Types::OutPoint.new(index: 0, tx_hash: "0x1b7af98007bf6128879798ac08fa26f863ded9aa3ebf1c04b321873b01042a21"), since: 0)
      output = CKB::Types::Output.new(capacity: 500000000000, lock: CKB::Types::Script.new(args: "0x59a27ef3ba84f061517d13f42cf44ed020610061", code_hash: "0x9bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce8", hash_type: "type"), type: nil)
      witness = CKB::Types::Witness.new(input_type: "", lock: "0x8702b06d59d6d0577ca55e6672bc6c21086e0b216d06e85605e965c82431f929082f222d5315139c246ad537ce77af0237a7de032f813504fc80a0b6e1327b2f00", output_type: "")
      tx = CKB::Types::Transaction.new(cell_deps: [cell_deps], hash: new_tx_hash, header_deps: [], inputs: [input], outputs: [output], outputs_data: ["0x"], version: 0, witnesses: [witness])
      tx.witnesses = tx.witnesses.map do |witness|
        case witness
        when CKB::Types::Witness
          CKB::Serializers::WitnessArgsSerializer.from(witness).serialize
        else
          witness
        end
      end

      tx
    end
end
