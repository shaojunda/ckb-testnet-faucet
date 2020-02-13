# frozen_string_literal: true

class UpdateOfficialAccountBalanceService
  def self.call
    api = CKB::API.new(host: Rails.application.credentials.CKB_NODE_URL)
    ckb_wallet = CKB::Wallet.from_hex(api, Rails.application.credentials.OFFICIAL_WALLET_PRIVATE_KEY)
    balance = api.get_capacity_by_lock_hash(ckb_wallet.lock_hash)
    Account.official_account.update(balance: balance.capacity)
  end
end
