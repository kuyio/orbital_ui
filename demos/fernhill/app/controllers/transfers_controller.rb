# frozen_string_literal: true

class TransfersController < ApplicationController
  def new; end

  def create
    amount = params[:amount].to_f
    return redirect_to(root_path) unless amount.positive? && Ledger::ACCOUNT_NAMES.include?(params[:to])

    session[:transfers] = ((session[:transfers] || []) + [{ "amount" => amount, "to" => params[:to] }]).last(5)
    redirect_to root_path, notice: "#{helpers.number_to_currency(amount)} is on its way to #{params[:to]}."
  end
end
