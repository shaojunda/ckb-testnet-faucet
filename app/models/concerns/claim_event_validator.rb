# frozen_string_literal: true

class ClaimEventValidator < ActiveModel::Validator
  MAXIMUM_CLAIM_COUNT_PER_IP_PER_DAY = 8
  MAXIMUM_PAYMENT_AMOUNT_PER_DAY = 4_000_000 * 10**8
  MINIMUM_ADDRESS_HASH_LENGTH = 40

  def validate(record)
    record.errors.add(:address_hash, "Address is invalid.") and return if record.address_hash.blank? || record.address_hash.length < MINIMUM_ADDRESS_HASH_LENGTH

    claim_interval_must_be_greater_than_3hours(record)
    receive_up_to_10_rewards_per_IP_per_day(record)
    address_hash_must_be_a_testnet_address(record)
    address_hash_must_be_short_payload_format(record)
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

    def address_hash_must_be_short_payload_format(record)
      parsed_address = CKB::AddressParser.new(record.address_hash).parse
      if parsed_address.address_type != "SHORTSINGLESIG"
        record.errors.add(:address_hash, "Address must be a blake160 short payload format.")
      end
    rescue NoMethodError, CKB::AddressParser::InvalidFormatTypeError
      record.errors.add(:address_hash, "Address is invalid.")
    end

    def receive_up_to_10_rewards_per_IP_per_day(record)
      if ClaimEvent.where(ip_addr: record.ip_addr).daily.count >= MAXIMUM_CLAIM_COUNT_PER_IP_PER_DAY
        record.errors.add(:address_hash, "Get up to 8 times claim per IP per day.")
      end
    end

    def claim_interval_must_be_greater_than_3hours(record)
      claim_event = ClaimEvent.where(address_hash: record.address_hash).where("created_at_unixtimestamp > ?", 3.hours.ago.to_i).pending.order(:id).first
      if claim_event.present?
        next_valid_time = Time.at(claim_event.created_at_unixtimestamp + 3.hours)
        record.errors.add(:address_hash, "Claim interval must be greater than 3hours. Next valid time is #{next_valid_time}.")
      end
    end
end
