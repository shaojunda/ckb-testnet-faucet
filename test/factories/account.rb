# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    address_hash do
      script = CKB::Types::Script.new(code_hash: "#{Rails.application.credentials.SECP_CELL_TYPE_HASH}", args: "0x#{SecureRandom.hex(20)}", hash_type: "type")

      CKB::Address.new(script, mode: CKB::MODE::TESTNET).generate
    end
    balance { Faker::Number.number(digits: 10) }
  end
end
