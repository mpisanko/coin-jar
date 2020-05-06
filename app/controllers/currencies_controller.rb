class CurrenciesController < ApplicationController
  include Pagy::Backend

  CURRENCIES = %w[BTCAUD ETHAUD]

  def index
    @currencies = CURRENCIES
    @latest = Price.latest(CURRENCIES)
  end

  def history
    @currencies = CURRENCIES
    @currency = params[:currency]
    if @currency
      @pagy, @prices = pagy(Price.for(@currency), items: 20)
    else
      redirect_to action: 'index'
    end
  end

  def capture
    CurrencyPrice.new.call
    redirect_to action: 'index', status: :found
  end
end
