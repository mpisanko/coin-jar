class CurrenciesController < ApplicationController
  def index

  end

  def history
  end

  def capture
    
  end

  def currencies
    @currencies = CurrencyPair.all
  end
  helper_method :currencies

end
