# frozen_string_literal: true

class ClaimEventValidator < ActiveModel::Validator
  MAXIMUM_CLAIM_COUNT_PER_IP_PER_DAY = 10000
  MAXIMUM_PAYMENT_AMOUNT_PER_DAY = 10_000_000 * 10**8
  MINIMUM_ADDRESS_HASH_LENGTH = 40

  def validate(record)
    record.errors.add(:address_hash, "Address is invalid.") && (return) if record.address_hash.blank? || record.address_hash.length < MINIMUM_ADDRESS_HASH_LENGTH

    only_claim_once_every_24h(record)
    receive_up_to_10_rewards_per_IP_per_day(record)
    address_hash_must_be_a_testnet_address(record)
    address_hash_cannot_be_short_multisig(record)
    address_hash_cannot_be_official_address(record)
    payment_amount_must_be_less_or_equal_to_daily_limit(record)
  end

  private
    def address_hash_cannot_be_official_address(record)
      record.errors.add(:address_hash, "Does not support transfers to official address.") if Account.exists?(address_hash: record.address_hash)
    end

    def payment_amount_must_be_less_or_equal_to_daily_limit(record)
      if ClaimEvent.daily.sum(:capacity) >= MAXIMUM_PAYMENT_AMOUNT_PER_DAY
        record.errors.add(:address_hash, "Faucet payment amount exceeds the daily limit.")
      end
    end

    def address_hash_must_be_a_testnet_address(record)
      parsed_address = CKB::AddressParser.new(record.address_hash).parse

      if parsed_address.mode != CKB::MODE::TESTNET
        record.errors.add(:address_hash, "Address must be a testnet address.")
      end
    rescue NoMethodError, CKB::AddressParser::InvalidFormatTypeError
      record.errors.add(:address_hash, "Address is invalid.")
    end

    def address_hash_cannot_be_short_multisig(record)
      parsed_address = CKB::AddressParser.new(record.address_hash).parse
      if parsed_address.address_type == "SHORTMULTISIG"
        record.errors.add(:address_hash, "Address cannot be multisig short payload format.")
      end
    rescue NoMethodError, CKB::AddressParser::InvalidFormatTypeError
      record.errors.add(:address_hash, "Address is invalid.")
    end

    def receive_up_to_10_rewards_per_IP_per_day(record)
      if ClaimEvent.where(ip_addr: record.ip_addr).daily.count >= MAXIMUM_CLAIM_COUNT_PER_IP_PER_DAY
        record.errors.add(:address_hash, "Get up to 10 times claim per IP per day.")
      end
    end

    def only_claim_once_every_24h(record)
      if ClaimEvent.where(address_hash: record.address_hash).h24.exists?
        record.errors.add(:address_hash, "An address can only be claimed once every 24 hours.")
      end
    end
end
