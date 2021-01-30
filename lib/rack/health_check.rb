# frozen_string_literal: true

module Rack
  class  HealthCheck
    WEEKLY_MINIMUM_QUOTA = (50000 * 100) * 7 * 10**8
    DAILY_MINIMUM_QUOTA = (50000 * 1000) * 10**8
    def call(env)
      req = Rack::Request.new(env)
      return [401, { "Content-Type" => "application/json" }, ["Ip Address not allowed"]] unless allowed_ip?(req.ip)

      health = OpenStruct.new(id: Time.current.to_i, balance_state: balance_state, rpc_connection_state: rpc_connection_state, claim_event_processor_state: claim_event_processor_state, daily_claim_amount_state: daily_claim_amount_state)

      [200, { "Content-Type" => "application/vnd.api+json" }, [HealthSerializer.new(health).serialized_json]]
    end

    protected
      def balance_state
        state = balance_less_than_the_amount_required_weekly? ? 1 : 0
        message = state == 1 ? "Alert! The current balance is #{account_balance}, which is lower than the weekly minimum quota" : ""

        { state: state, message: message }
      end

      def rpc_connection_state
        state = rpc_connected? ? 0 : 1
        message = state == 1 ? "Alert! The RPC connection has been broken" : ""

        { state: state, message: message }
      end

      def claim_event_processor_state
        state = claim_event_processor_status == "delayed" ? 1 : 0
        message = state == 1 ? "Alert! The claim processor has been delayed" : ""

        { state: state, message: message }
      end

      def daily_claim_amount_state
        state = daily_claim_amount_greater_than_the_daily_max_claim_amount? ? 1 : 0
        message = state == 1 ? "Alert! The daily claim amount is #{daily_claim_amount} exceeds the daily limit." : ""

        { state: state, message: message }
      end

      def balance_less_than_the_amount_required_weekly?
        account_balance < WEEKLY_MINIMUM_QUOTA
      end

      def daily_claim_amount_greater_than_the_daily_max_claim_amount?
        daily_claim_amount >= ClaimEventValidator::MAXIMUM_PAYMENT_AMOUNT_PER_DAY
      end

      def account_balance
        @accounts_balance ||= Account.last.balance
      end

      def rpc_connected?
        CKB::API.new(host: Rails.application.credentials.CKB_NODE_URL).present? rescue false
      end

      def allowed_ip?(remote_ip)
        return true unless Rails.application.credentials.ENABLE_ALLOWED_IPS

        allowed_ips = %w[127.0.0.1 ::1].concat(Rails.application.credentials.ALLOWED_IPS || [])
        allowed_ips.include?(remote_ip)
      end

      def claim_event_processor_status
        current_timestamp = Time.current.to_i
        ClaimEvent.pending.recent.limit(10).pluck(:created_at_unixtimestamp).any? { |timestamp| current_timestamp - timestamp > 10.minutes } ? "delayed" : "normal"
      end

      def daily_claim_amount
        @daily_claim_amount ||= ClaimEvent.processed.daily.sum(:capacity) / 10**8
      end
  end
end
