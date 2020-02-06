class ClaimEvent < ApplicationRecord
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
#  status                   :integer          default(0)
#  tx_hash                  :string
#  tx_status                :integer          default(0)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  ckb_transaction_id       :bigint
#
