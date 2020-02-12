require_relative "../config/environment"

api = CKB::API.new(host: Rails.application.credentials.CKB_NODE_URL)
ckb_wallet = CKB::Wallet.from_hex(api, Rails.application.credentials.OFFICIAL_WALLET_PRIVATE_KEY)
send_capacity_service = SendCapacityService.new(ckb_wallet)

loop do
  send_capacity_service.call
end
