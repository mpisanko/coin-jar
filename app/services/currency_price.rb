require 'rest_client'

# Currency Price Service - reads CoinJar price ticker
class CurrencyPrice
  TICKER = 'https://data.exchange.coinjar.com/products/%s/ticker'.freeze

  # In spite of GIL and Ruby's lack of REAL Threads - this HTTP requests are
  # IO bound so it's OK to 'multithread' here
  def call
    %i[ethaud btcaud].map do |currency|
      Thread.new do
        send(currency)
      end
    end.map(&:value).reduce(&:merge)
  end

  def btcaud
    { btcaud: save_price('BTCAUD') }
  end

  def ethaud
    { ethaud: save_price('ETHAUD') }
  end

  private

  def request_price(currency)
    response = RestClient.get(TICKER % currency)
    ActiveSupport::JSON.decode(response.body)
  end

  def save_price(currency)
    begin
      json_price = request_price(currency)
      Price.create(
        last:          json_price["last"].to_d,
        bid:           json_price["bid"].to_d,
        ask:           json_price["ask"].to_d,
        price_at:      json_price["current_time"].to_time,
        currency:      currency
      )
    rescue RestClient::Exception => e
      Rails.logger.error("Problem GETting #{TICKER % currency}: #{e}")
      nil
    rescue ActiveRecord::ActiveRecordError => e
      Rails.logger.error("Problem saving price for #{currency}: #{e}")
      nil
    end
  end
end
