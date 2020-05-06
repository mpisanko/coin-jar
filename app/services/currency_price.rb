require 'rest_client'

# Currency Price Service - reads CoinJar price ticker
class CurrencyPrice
  TICKER = 'https://data.exchange.coinjar.com/products/%s/ticker'.freeze

  def btc
    save_price(CurrencyPair.find_by(currency_1: 'BTC'))
  end

  def eth
    save_price(CurrencyPair.find_by(currency_1: 'ETH'))
  end

  private

  def request_price(currency_pair)
    response = RestClient.get(TICKER % currency_pair.to_s)
    ActiveSupport::JSON.decode(response.body)
  end

  def save_price(currency)
    json_price = request_price(currency)
    Price.new(
      last:          json_price["last"].to_d,
      bid:           json_price["bid"].to_d,
      ask:           json_price["ask"].to_d,
      price_at:      json_price["current_time"].to_time,
      currency_pair: currency
    ).tap(&:save)
  end
end
