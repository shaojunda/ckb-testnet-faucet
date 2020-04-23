# frozen_string_literal: true

require_relative "../config/environment"

api = CKB::API.new(host: Rails.application.credentials.CKB_NODE_URL)
ckb_wallet = CKB::Wallets::NewWallet.new(api: api, from_addresses: Account.last.address_hash, collector_type: :default_indexer)

loop do
  SendCapacityService.new(ckb_wallet).call
end
