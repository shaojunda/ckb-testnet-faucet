# frozen_string_literal: true

require "test_helper"

class ClaimEventTest < ActiveSupport::TestCase
  context "validations" do
    should validate_presence_of(:address_hash).on(:create)
    should validate_presence_of(:capacity).on(:create)
    should validate_presence_of(:created_at_unixtimestamp).on(:create)
    should validate_presence_of(:ip_addr).on(:create)
  end
end
