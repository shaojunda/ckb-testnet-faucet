# frozen_string_literal: true

class ClaimEventsController < ApplicationController
  def index
    account = Account.official_account
    claim_events = ClaimEvent.recent.limit(ClaimEvent::DEFAULT_CLAIM_EVENT_SIZE)

    render json: { claimEvents: ClaimEventSerializer.new(claim_events).serializable_hash, official_account: { addressHash: account.address_hash, balance: account.ckb_balance } }
  end

  def create
    claim_event = ClaimEvent.new(claim_events_params.merge(created_at_unixtimestamp: Time.current.to_i,
      capacity: ClaimEvent::DEFAULT_CLAIM_CAPACITY, ip_addr: request.remote_ip))

    if claim_event.save
      render json: ClaimEventSerializer.new(claim_event)
    else
      render json: claim_event.errors, status: :unprocessable_entity
    end
  end

  private
    def claim_events_params
      params.require(:claim_event).permit(:address_hash)
    end
end
