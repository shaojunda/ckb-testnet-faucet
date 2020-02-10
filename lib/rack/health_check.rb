# frozen_string_literal: true

module Rack
  class  HealthCheck
    def call(env)
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
  end
end
