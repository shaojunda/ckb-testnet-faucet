# frozen_string_literal: true

class SendCapacityService
  def call
    ClaimEvent.transaction do
      pending_events = ClaimEvent.order(:id).pending.limit(100)
      return if pending_events.blank?

      first_pending_event = pending_events.first
      first_pending_event.lock!
      if first_pending_event.tx_hash.present?
        tx = api.get_transaction(first_pending_event.tx_hash)

        if tx.present?
          handle_state_change(pending_events, tx)
        else
          handle_send_capacity(pending_events)
        end
      else
        handle_send_capacity(pending_events)
      end
    end
  end

  private
    def ckb_wallet
      @ckb_wallet ||= CKB::Wallets::NewWallet.new(api: api, indexer_api: indexer_api, from_addresses: Account.last.address_hash)
    end

    def api
      @api ||= SdkApi.instance
    end

    def indexer_api
      @indexer_api || SdkApi.instance.indexer_api
    end

    def handle_state_change(pending_events, tx)
      return if tx.tx_status.status == "pending"

      if tx.tx_status.status == "committed"
        pending_events.update_all(status: "processed")
        pending_events.update_all(tx_status: tx.tx_status.status)
        Account.official_account.decrement!(:balance, pending_events.sum(:capacity))
      else
        pending_events.update_all(tx_status: tx.tx_status.status)
      end
    end

    def handle_send_capacity(pending_events)
      to_infos = pending_events.inject({}) do |memo, event|
        if memo[event.address_hash].present?
          memo[event.address_hash] = { capacity: event.capacity + memo[event.address_hash][:capacity] }
        else
          memo[event.address_hash] = { capacity: event.capacity }
        end
        memo
      end
      tx_generator = ckb_wallet.advance_generate(to_infos: to_infos)
      tx = ckb_wallet.sign(tx_generator, Rails.application.credentials.OFFICIAL_WALLET_PRIVATE_KEY)
      tx_hash = api.send_transaction(tx)
      pending_events.update_all(tx_hash: tx_hash, tx_status: "pending", fee: tx_fee(tx))
    rescue CKB::RPCError => e
      puts e
    end

    def tx_fee(tx)
      input_capacities = tx.inputs.map { |input| api.get_transaction(input.previous_output.tx_hash).transaction.outputs[input.previous_output.index].capacity }.sum
      output_capacities = tx.outputs.map(&:capacity).sum

      input_capacities - output_capacities
    end
end
