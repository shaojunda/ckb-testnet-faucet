# frozen_string_literal: true

class HealthSerializer
  include FastJsonapi::ObjectSerializer

  attributes :balance_state, :rpc_connection_state, :claim_event_processor_state, :daily_claim_amount_state
end
