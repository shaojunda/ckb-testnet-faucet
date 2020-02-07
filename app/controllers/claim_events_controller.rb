# frozen_string_literal: true

class ClaimEventsController < ApplicationController
  def create
    claim_event = ClaimEvent.new(claim_events_params)
    if claim_event.save
      render json: claim_event
    else
      render json: claim_event.errors, status: :unprocessable_entity
    end
  end

  private

  def claim_events_params
    params.require(:claim_event).permit(:address_hash)
  end
end
