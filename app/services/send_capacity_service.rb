# frozen_string_literal: true

class SendCapacityService
  def initialize(ckb_wallet)
    @ckb_wallet = ckb_wallet
  end

  def call
    ClaimEvent.transaction do
      first_pending_event = ClaimEvent.order(:id).pending.first
      first_pending_event.lock!
      if first_pending_event.tx_hash.present?
      else
        tx_hash = ckb_wallet.send_capacity(first_pending_event.address_hash, first_pending_event.capacity)
        first_pending_event.update!(tx_hash: tx_hash, tx_status: "pending")
      end
    end
  end

  private
    attr_reader :ckb_wallet
end
