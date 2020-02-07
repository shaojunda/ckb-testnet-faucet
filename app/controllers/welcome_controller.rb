# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    render component: "Welcome"
  end
end
