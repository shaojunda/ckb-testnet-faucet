# frozen_string_literal: true

require "test_helper"

class AccountTest < ActiveSupport::TestCase
  context "validations" do
    should validate_presence_of(:address_hash)
    should validate_presence_of(:balance)
    should validate_numericality_of(:balance).
     is_greater_than_or_equal_to(0)
  end
end
