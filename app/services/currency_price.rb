require 'rest_client'

# Currency Price Service - reads CoinJar price ticker
class CurrencyPrice
  TICKER = 'https://data.exchange.coinjar.com/products/%s/ticker'.freeze

  def btc
    { btc: save_price(CurrencyPair.find_by(currency_1: 'BTC')) }
  end

  def eth
    { eth: save_price(CurrencyPair.find_by(currency_1: 'ETH')) }
  end

  private

  def request_price(currency)
    response = RestClient.get(TICKER % currency.to_s)
    ActiveSupport::JSON.decode(response.body)
  end

  def save_price(currency)
    begin
      json_price = request_price(currency)
      Price.new(
        last:          json_price["last"].to_d,
        bid:           json_price["bid"].to_d,
        ask:           json_price["ask"].to_d,
        price_at:      json_price["current_time"].to_time,
        currency_pair: currency
      ).tap(&:save)
    rescue RestClient::Exception => e
      Rails.logger.error("Problem GETting #{TICKER % currency.to_s}: #{e}")
      nil
    rescue ActiveRecord::ActiveRecordError => e
      Rails.logger.error("Problem saving price for #{currency}: #{e}")
      nil
    end
  end
end
