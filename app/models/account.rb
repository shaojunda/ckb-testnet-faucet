# frozen_string_literal: true

class Account < ApplicationRecord
  validates_presence_of :address_hash, :balance
  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  def self.official_account
    first
  end
end

# == Schema Information
#
# Table name: accounts
#
#  id           :bigint           not null, primary key
#  address_hash :string
#  balance      :decimal(30, )    default(0)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
