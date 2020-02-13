# frozen_string_literal: true

namespace :migration do
  task create_official_account: :environment do
    api = CKB::API.new(host: Rails.application.credentials.CKB_NODE_URL)
    ckb_wallet = CKB::Wallet.from_hex(api, Rails.application.credentials.OFFICIAL_WALLET_PRIVATE_KEY)
    api.index_lock_hash(ckb_wallet.lock_hash)
    balance = api.get_capacity_by_lock_hash(ckb_wallet.lock_hash)
    Account.create(address_hash: ckb_wallet.address, balance: balance.capacity)

    puts "done"
  end
end
