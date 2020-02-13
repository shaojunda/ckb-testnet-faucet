# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    account = Account.first
    render component: "Welcome", props: { officialAccount: { address_hash: account.address_hash, balance: account.balance } }
  end
end
