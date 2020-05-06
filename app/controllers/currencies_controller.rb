class CurrenciesController < ApplicationController
  include Pagy::Backend

  def index
    @currencies = CurrencyPair.all
  end

  def history
    @currencies = CurrencyPair.all
    @currency = @currencies.find_by(currency_1: params[:id])
    if @currency
      @pagy, @prices = pagy(@currency.prices, items: 10)
    else
      flash[:alert] = 'Please select currency to show.'
      redirect_to action: 'index'
    end
  end

  def capture
    CurrencyPrice.new.call
    redirect_to action: 'index', status: :found
  end
end
