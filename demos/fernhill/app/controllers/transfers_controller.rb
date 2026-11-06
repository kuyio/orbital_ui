# frozen_string_literal: true

class TransfersController < ApplicationController
  def new
    @transfer = Transfer.new
  end

  def create
    @transfer = Transfer.new(params.expect(transfer: %i[from to amount]))
    return render(:new, status: :unprocessable_content) unless @transfer.valid?

    session[:transfers] = ((session[:transfers] || []) + [@transfer.to_session]).last(5)
    # The flash is for the request the refresh below makes, so flash.now would lose it.
    flash[:notice] = "#{helpers.number_to_currency(@transfer.amount)} is on its way to #{@transfer.to}." # rubocop:disable Rails/ActionControllerFlashBeforeRender

    # The form is inside the dialog's frame. Errors stay there, and success reloads the page around it.
    render turbo_stream: turbo_stream.refresh(request_id: nil)
  end
end
