# frozen_string_literal: true

class ClaimEvent < ApplicationRecord
  enum status: { pending: 0, processed: 1 }
  enum tx_status: { pending: 0, proposed: 1, committed: 2 }, _prefix: :tx
end

# == Schema Information
#
# Table name: claim_events
#
#  id                       :bigint           not null, primary key
#  address_hash             :string
#  capacity                 :integer
#  created_at_unixtimestamp :integer
#  fee                      :decimal(20, )
#  ip_addr                  :inet
#  status                   :integer          default("pending")
#  tx_hash                  :string
#  tx_status                :integer          default("pending")
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  ckb_transaction_id       :bigint
#
