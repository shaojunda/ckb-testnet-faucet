# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    account = Account.official_account
    claim_events = ClaimEvent.recent.limit(ClaimEvent::DEFAULT_CLAIM_EVENT_SIZE)

    render component: "Welcome", props: { claim_events: ClaimEventSerializer.new(claim_events).serializable_hash, official_account: { address_hash: account.address_hash, balance: account.ckb_balance }, aggron_explorer_host: Rails.application.credentials.AGGRON_EXPLORER_HOST }
  end
end
