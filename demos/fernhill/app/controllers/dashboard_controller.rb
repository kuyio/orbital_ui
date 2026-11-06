# frozen_string_literal: true

class DashboardController < ApplicationController
  def show
    @ledger = Ledger.new(session[:transfers] || [])
  end
end
