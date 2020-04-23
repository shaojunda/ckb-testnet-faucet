# frozen_string_literal: true

class SendCapacityService
  def initialize(ckb_wallet)
    @ckb_wallet = ckb_wallet
    @api = ckb_wallet.api
  end

  def call
    ClaimEvent.transaction do
      first_pending_event = ClaimEvent.order(:id).pending.first
      return if first_pending_event.blank?

      first_pending_event.lock!
      if first_pending_event.tx_hash.present?
        tx = api.get_transaction(first_pending_event.tx_hash)

        if tx.present?
          handle_state_change(first_pending_event, tx)
        else
          handle_send_capacity(first_pending_event)
        end
      else
        handle_send_capacity(first_pending_event)
      end
    end
  end

  private
    attr_reader :ckb_wallet, :api

    def handle_state_change(first_pending_event, tx)
      return if tx.tx_status.status == "pending"

      if tx.tx_status.status == "committed"
        first_pending_event.processed!
        first_pending_event.update!(tx_status: tx.tx_status.status)
        Account.official_account.decrement!(:balance, first_pending_event.capacity)
      else
        first_pending_event.update!(tx_status: tx.tx_status.status)
      end
    end

    def handle_send_capacity(first_pending_event)
      tx_generator = ckb_wallet.generate(first_pending_event.address_hash, first_pending_event.capacity)
      tx = ckb_wallet.sign(tx_generator, Rails.application.credentials.OFFICIAL_WALLET_PRIVATE_KEY)
      tx_hash = api.send_transaction(tx)
      first_pending_event.update!(tx_hash: tx_hash, tx_status: "pending", fee: min_tx_fee)
    rescue CKB::RPCError => e
      puts e
    end
end
