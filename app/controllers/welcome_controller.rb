# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    account = Account.official_account
    render component: "Welcome", props: { officialAccount: { address_hash: account.address_hash, balance: account.balance } }
  end
end
