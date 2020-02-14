# frozen_string_literal: true

class ClaimEventSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower

  attributes :address_hash, :status, :tx_hash, :tx_status, :id

  attribute :timestamp, &:created_at_unixtimestamp
  attribute :fee do |object|
    object.tx_status == "pending" ? "" : (BigDecimal(object.fee) / 10**8).to_s
  end
  attribute :capacity do |object|
    (BigDecimal(object.capacity) / 10**8).to_s
  end
end
