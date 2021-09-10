# frozen_string_literal: true

class SendCapacityService
  def call
    ClaimEvent.transaction do
      pending_events = ClaimEvent.order(:id).pending.limit(100).group_by(&:tx_hash)
      return if pending_events.blank?
      if pending_events.keys.compact.size > 1
        ClaimEvent.where(id: pending_events.values.flatten.pluck(:id)).update_all(tx_hash: nil)
        pending_events.values.flatten.map(&:touch)
        api.clear_tx_pool
      end

      pending_events.each do |tx_hash, events|
        if tx_hash.present?
          tx = api.get_transaction(tx_hash)

          if tx.present?
            handle_state_change(events, tx)
          else
            handle_send_capacity(events)
          end
        else
          handle_send_capacity(events)
        end
      end
    end
  end

  private
    def ckb_wallet
      @ckb_wallet ||= CKB::Wallets::NewWallet.new(api: api, indexer_api: indexer_api, from_addresses: Account.last.address_hash)
    end

    def api
      @api ||= SdkApi.instance.api
    end

    def indexer_api
      @indexer_api || SdkApi.instance.indexer_api
    end

    def handle_state_change(pending_events, tx)
      return if tx.tx_status.status == "pending"

      if tx.tx_status.status == "committed"
        pending_events.map { |pending_event| pending_event.processed! }
        pending_events.map { |pending_event| pending_event.update!(tx_status: tx.tx_status.status) }
        Account.official_account.decrement!(:balance, pending_events.inject(0) { |sum, event| sum + event.capacity })
      else
        pending_events.map { |pending_event| pending_event.update!(tx_status: tx.tx_status.status) }
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
      pending_events.map { |pending_event| pending_event.update!(tx_hash: tx_hash, tx_status: "pending", fee: tx_fee(tx)) }
    rescue CKB::RPCError => e
      puts e
    end

    def tx_fee(tx)
      input_capacities = tx.inputs.map { |input| api.get_transaction(input.previous_output.tx_hash).transaction.outputs[input.previous_output.index].capacity }.sum
      output_capacities = tx.outputs.map(&:capacity).sum

      input_capacities - output_capacities
    end
end
