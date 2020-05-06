require 'rails_helper'

RSpec.describe "Currencies", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/currencies/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /history" do
    it "returns http redirect without valid currency" do
      get "/currencies/history"
      expect(response).to have_http_status(:redirect)
    end

    it 'returns http success' do
      currency = CurrencyPair.new(currency_1: 'BTC', currency_2: 'AUD').tap(&:save)
      get "/currencies/history?id=#{currency.currency_1}"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /capture" do
    it "performs a query and http redirects" do
      get "/currencies/capture"
      expect(response).to have_http_status(:redirect)
    end
  end

end
