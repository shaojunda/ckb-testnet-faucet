# frozen_string_literal: true

class ClaimEvent < ApplicationRecord
  DEFAULT_CLAIM_CAPACITY = 10000 * 10**8
  DEFAULT_CLAIM_EVENT_SIZE = 15
  enum status: { pending: 0, processed: 1 }
  enum tx_status: { pending: 0, proposed: 1, committed: 2, rejected: 3 }, _prefix: :tx

  validates_presence_of :address_hash, :capacity, :created_at_unixtimestamp, :ip_addr, on: :create
  validates_with ClaimEventValidator, on: :create

  scope :daily, -> { where("created_at_unixtimestamp >= ? and created_at_unixtimestamp <= ?", Time.current.beginning_of_day.to_i, Time.current.end_of_day.to_i) }
  scope :h24, -> { where("created_at_unixtimestamp >= ?", 24.hours.ago.to_i) }
  scope :recent, -> { order(id: :desc) }
end

# == Schema Information
#
# Table name: claim_events
#
#  id                       :bigint           not null, primary key
#  address_hash             :string
#  capacity                 :decimal(30, )
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
