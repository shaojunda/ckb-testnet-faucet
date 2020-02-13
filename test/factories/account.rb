# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    address_hash do
      script = CKB::Types::Script.new(code_hash: "#{Rails.application.credentials.SECP_CELL_TYPE_HASH}", args: "0x#{SecureRandom.hex(20)}", hash_type: "type")

      CKB::Address.new(script, mode: CKB::MODE::TESTNET).generate
    end
    balance { 10_000_000 * 10**8 }
  end
end
