# frozen_string_literal: true

module Rack
  class  HealthCheck
    def call(env)
      req = Rack::Request.new(env)
      return [401, { "Content-Type" => "application/json" }, ["Ip Address not allowed"]] unless allowed_ip?(req.ip)

      status = {
        redis: {
          connected: redis_connected?
        },
        postgres: {
          connected: postgres_connected?,
          migrations_updated: postgres_migrations_updated?
        },
        accounts: {
          balances: accounts_balance
        },
        rpc: {
          connected: rpc_connected?
        }
      }

      [200, { "Content-Type" => "application/json" }, [status.to_json]]
    end

    protected
      def redis_connected?
        $redis.ping == "PONG" rescue false
      end

      def postgres_connected?
        ApplicationRecord.establish_connection
        ApplicationRecord.connection
        ApplicationRecord.connected?
      rescue
        false
      end

      def postgres_migrations_updated?
        return false unless postgres_connected?

        !ApplicationRecord.connection.migration_context.needs_migration?
      end

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
  end
end
