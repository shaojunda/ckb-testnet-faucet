# frozen_string_literal: true

module Rack
  class  HealthCheck
    def call(env)
      req = Rack::Request.new(env)
      return [401, { "Content-Type" => "application/json" }, ["Ip Address not allowed"]] unless allowed_ip?(req.ip)

      status = {
        accounts: {
          balances: accounts_balance
        },
        rpc: {
          connected: rpc_connected?
        },
        claim_event_processor_status: claim_event_processor_status,
        daily_claim_amount: daily_claim_amount
      }

      [200, { "Content-Type" => "application/json" }, [status.to_json]]
    end

    protected
      def accounts_balance
        Account.all.pluck(:address_hash, :balance)
      end

      def rpc_connected?
        CKB::API.new(host: Rails.application.credentials.CKB_NODE_URL).present? rescue false
      end

      def allowed_ip?(remote_ip)
        allowed_ips = ["127.0.0.1", "::1"].concat(Rails.application.credentials.ALLOWED_IPS || [])
        allowed_ips.include?(remote_ip)
      end

      def claim_event_processor_status
        current_timestamp = Time.current.to_i
        ClaimEvent.pending.recent.limit(10).pluck(:created_at_unixtimestamp).any? { |timestamp| current_timestamp - timestamp > 10.minutes } ? "delayed" : "normal"
      end

      def daily_claim_amount
        ClaimEvent.processed.daily.sum(:capacity) / 10**8
      end
  end
end
